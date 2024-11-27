//
//  MyPageInfoViewModel.swift
//  WSSiOS
//
//  Created by 신지원 on 7/22/24.
//

import Foundation

import RxSwift
import RxCocoa

final class MyPageInfoViewModel: ViewModelType {
    
    //MARK: - Properties
    
    private let userRepository: UserRepository
    private let authRepository: AuthRepository
    
    private let settingList = StringLiterals.MyPage.SettingInfo.allCases.map { $0.rawValue }
    
    //MARK: - Life Cycle
    
    init(userRepository: UserRepository, authRepository: AuthRepository) {
        self.userRepository = userRepository
        self.authRepository = authRepository
    }
    
    struct Input {
        let cellDidTapped: ControlEvent<IndexPath>
        let logoutButtonTapped: PublishRelay<Bool>
        let backButtonDidTap: ControlEvent<Void>
    }
    
    struct Output {
        let bindSettingCell = BehaviorRelay<[String]>(value: [""])
        let pushToChangeUserInfoViewController = PublishRelay<ChangeUserInfo>()
        let pushToBlockIDViewController = PublishRelay<Void>()
        let presentToAlertViewController = PublishRelay<Void>()
        let pushToMyPageDeleteIDWarningViewController = PublishRelay<Void>()
        let pushToLoginViewController = PublishRelay<Void>()
        
        let popViewController = PublishRelay<Bool>()
        let bindEmail = BehaviorRelay<String>(value: "")
        let genderAndBirth = BehaviorRelay<ChangeUserInfo>(value: ChangeUserInfo(gender: "", birth: 0))
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        Observable.just(settingList)
            .bind(to: output.bindSettingCell)
            .disposed(by: disposeBag)
        
        input.backButtonDidTap
            .throttle(.seconds(3), scheduler: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, _ in
                output.popViewController.accept(true)
            })
            .disposed(by: disposeBag)
        
        input.cellDidTapped
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, indexPath in
                switch indexPath.row {
                case 0:
                    //성별/나이 변경
                    output.pushToChangeUserInfoViewController.accept(output.genderAndBirth.value)
                case 1:
                    //이메일
                    break;
                case 2:
                    //차단유저 목록
                    output.pushToBlockIDViewController.accept(())
                case 3:
                    //로그아웃
                    output.presentToAlertViewController.accept(())
                case 4:
                    //회원탈퇴
                    output.pushToMyPageDeleteIDWarningViewController.accept(())
                default: break
                }
            })
            .disposed(by: disposeBag)
        
        Observable.just(())
            .flatMapLatest { [weak self] _ -> Observable<UserInfo> in
                guard let self = self else { return Observable.empty() }
                return self.getUserInfo()
            }
            .subscribe(with: self, onNext: { owner, data in
                output.genderAndBirth.accept(ChangeUserInfo(gender: data.gender,
                                                            birth: data.birth))

                UserDefaults.standard.set(data.birth, forKey: StringLiterals.UserDefault.userBirth)
                
                guard let email = data.email, !email.isEmpty else { return }
                output.bindEmail.accept(email)
            }, onError: { owner, error in
                print(error)
            })
            .disposed(by: disposeBag)
        
        input.logoutButtonTapped
            .throttle(.seconds(3), scheduler: MainScheduler.instance)
            .flatMapLatest { [weak self] _ -> Observable<Void> in
                guard let self = self else { return Observable.empty() }
                guard let refreshTokenString = UserDefaults.standard.string(forKey: StringLiterals.UserDefault.refreshToken) else { return Observable.empty() }
                return self.postLogout(refreshToken: refreshTokenString)
            }
            .subscribe(
                onNext: {
                    UserDefaults.standard.removeObject(forKey: StringLiterals.UserDefault.accessToken)
                    UserDefaults.standard.removeObject(forKey: StringLiterals.UserDefault.refreshToken)
                    output.pushToLoginViewController.accept(())
                },
                onError: { error in
                    print(error.localizedDescription)
                }
            )
            .disposed(by: disposeBag)
        
        return output
    }
    
    //MARK: - API
    
    private func getUserInfo() -> Observable<UserInfo> {
        return userRepository.getUserInfo()
            .observe(on: MainScheduler.instance)
        
//        return UserInfo(email: "", gender: "F", birth: 2000)
    }
    
    private func postLogout(refreshToken: String) -> Observable<Void> {
        return authRepository.postLogout(refreshToken: refreshToken)
            .asObservable()
    }
}

