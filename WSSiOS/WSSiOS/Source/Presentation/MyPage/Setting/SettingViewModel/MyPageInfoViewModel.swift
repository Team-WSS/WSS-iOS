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
    
    }
    
    struct Output {
        let bindEmail = BehaviorRelay(value: "")
        let genderAndBirth = PublishRelay<ChangeUserInfo>()
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
       
        getUserInfo()
            .subscribe(with: self, onNext: { owner, data in
                output.bindEmail.accept(data.email)
                output.genderAndBirth.accept(ChangeUserInfo(gender: data.gender,
                                                            birth: data.birth))
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
}

