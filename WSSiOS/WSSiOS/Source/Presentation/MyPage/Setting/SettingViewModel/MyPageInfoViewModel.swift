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
    
    //MARK: - Life Cycle
    
    init(userRepository: UserRepository, authRepository: AuthRepository) {
        self.userRepository = userRepository
        self.authRepository = authRepository
    }
    
    struct Input {
        let logoutButtonTapped: PublishRelay<Bool>
        let backButtonDidTap: ControlEvent<Void>
        let updateUserInfo: BehaviorRelay<Bool>
    }
    
    struct Output {
        let popViewController = PublishRelay<Bool>()
        let bindEmail = BehaviorRelay<String>(value: "")
        let genderAndBirth = PublishRelay<ChangeUserInfo>()
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.backButtonDidTap
            .throttle(.seconds(3), scheduler: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, _ in
                output.popViewController.accept(true)
            })
            .disposed(by: disposeBag)
        
        input.updateUserInfo
            .subscribe(with: self, onNext: { owner, update in
                if update {
                    owner.getUserInfo()
                        .subscribe(with: self, onNext: { owner, data in
                            output.genderAndBirth.accept(ChangeUserInfo(gender: data.gender,
                                                                        birth: data.birth))
                        })
                        .disposed(by: disposeBag)
                }
            })
            .disposed(by: disposeBag)
        
        getUserInfo()
            .subscribe(with: self, onNext: { owner, data in
                output.bindEmail.accept(data.email)
                output.genderAndBirth.accept(ChangeUserInfo(gender: data.gender,
                                                            birth: data.birth))
            }, onError: { owner, error in
                print(error)
            })
            .disposed(by: disposeBag)
        
        input.logoutButtonTapped
            .throttle(.seconds(3), scheduler: MainScheduler.asyncInstance)
            .flatMapLatest { [weak self] _ -> Observable<Void> in
                guard let self = self else { return Observable.empty() }
                let refreshToken = UserDefaults.standard.string(forKey: StringLiterals.UserDefault.refreshToken) ?? ""
                return self.postLogout(refreshToken: refreshToken)
            }
            .subscribe(
                onNext: {
                    UserDefaults.standard.removeObject(forKey: StringLiterals.UserDefault.refreshToken)
                    
//                    output.pushToLoginViewController.accept(true)
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
    
    private func postLogout(refreshToken: String) -> Observable<Void> {
        return authRepository.postLogout(refreshToken: refreshToken)
            .asObservable()
    }
}

