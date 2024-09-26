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
    
    //MARK: - Life Cycle
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
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
            .subscribe(with: self, onNext: { owner, _ in
                owner.logout()
            }, onError: { owner, error in
                print(error)
            })
            .disposed(by: disposeBag)
        
        return output
    }
    
    //MARK: - API
    
    private func getUserInfo() -> Observable<UserInfo> {
        return userRepository.getUserInfo()
            .observe(on: MainScheduler.instance)
    }
    
    private func logout() {
        print("로그아웃 로직 구현")
    }
}

