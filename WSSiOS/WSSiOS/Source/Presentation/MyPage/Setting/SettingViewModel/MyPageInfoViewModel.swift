//
//  MyPageInfoViewModel.swift
//  WSSiOS
//
//  Created by 신지원 on 7/22/24.
//

import Foundation

import RxSwift
import RxCocoa

enum PushToViewControllerFromInfoViewController {
    case changeUserInfo
    case blockUser
    case myPageDeleteIDWarning
    case logoutAlert
    case login
}

final class MyPageInfoViewModel: ViewModelType {
    
    //MARK: - Properties
    
    private let userRepository: UserInfoRepository
    private let authRepository: AuthRepository
    
    private let settingList = StringLiterals.MyPage.SettingInfo.allCases.map { $0.rawValue }
    
    //MARK: - Life Cycle
    
    init(userRepository: UserInfoRepository, authRepository: AuthRepository) {
        self.userRepository = userRepository
        self.authRepository = authRepository
    }
    
    struct Input {
        let cellDidTapped: ControlEvent<IndexPath>
        let logoutButtonTapped: PublishRelay<Bool>
    }
    
    struct Output {
        let cellData = BehaviorRelay<[String]>(value: [""])
        let emailData = BehaviorRelay<String>(value: "")
        let genderAndBirthData = BehaviorRelay<ChangeUserInfo>(value: ChangeUserInfo(gender: "", birth: 0))
        let pushToOtherViewController = PublishRelay<PushToViewControllerFromInfoViewController>()
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        Observable.just(settingList)
            .bind(to: output.cellData)
            .disposed(by: disposeBag)
        
        input.cellDidTapped
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, indexPath in
                switch indexPath.row {
                case 0:
                    //성별|나이 변경
                    output.pushToOtherViewController.accept(.changeUserInfo)
                case 1:
                    //이메일
                    break;
                case 2:
                    //차단유저 목록
                    output.pushToOtherViewController.accept(.blockUser)
                case 3:
                    //로그아웃
                    output.pushToOtherViewController.accept(.logoutAlert)
                case 4:
                    //회원탈퇴
                    output.pushToOtherViewController.accept(.myPageDeleteIDWarning)
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
        
        Observable.just(())
            .flatMapLatest { [weak self] _ -> Observable<UserInfo> in
                guard let self = self else { return Observable.empty() }
                return self.getUserInfo()
            }
            .subscribe(with: self, onNext: { owner, data in
                output.genderAndBirthData.accept(ChangeUserInfo(gender: data.gender, birth: data.birth))
                UserDefaults.standard.set(data.birth, forKey: StringLiterals.UserDefault.userBirth)
                
                guard let email = data.email, !email.isEmpty else { return }
                output.emailData.accept(email)
            }, onError: { owner, error in
                print(error)
            })
            .disposed(by: disposeBag)
        
        input.logoutButtonTapped
            .throttle(.seconds(3), scheduler: MainScheduler.instance)
            .flatMapLatest { [weak self] _ -> Observable<Void> in
                guard let self = self else { return Observable.empty() }
                guard let refreshTokenString = UserDefaults.standard.string(forKey: StringLiterals.UserDefault.refreshToken) else { return Observable.empty() }
                guard let deviceIdentifierString = try? KeychainHelper.shared.readString(forKey: StringLiterals.KeyChain.deviceIdentifier) else { return Observable.empty() }
                
                return self.postLogout(refreshToken: refreshTokenString, deviceIdentifier: deviceIdentifierString)
            }
            .subscribe(
                onNext: {
                    UserDefaults.standard.removeObject(forKey: StringLiterals.UserDefault.userId)
                    UserDefaults.standard.removeObject(forKey: StringLiterals.UserDefault.userNickname)
                    UserDefaults.standard.removeObject(forKey: StringLiterals.UserDefault.userGender)
                    UserDefaults.standard.removeObject(forKey: StringLiterals.UserDefault.accessToken)
                    UserDefaults.standard.removeObject(forKey: StringLiterals.UserDefault.refreshToken)
                    
                    output.pushToOtherViewController.accept(.login)
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
    }
    
    private func postLogout(refreshToken: String, deviceIdentifier: String) -> Observable<Void> {
        return authRepository.postLogout(refreshToken: refreshToken, deviceIdentifier: deviceIdentifier)
    }
}

