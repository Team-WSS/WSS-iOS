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
    }
    
    struct Output {
        let email = BehaviorRelay(value: "")
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
       
        getUserEmail()
            .subscribe(with: self, onNext: { owner, email in
                output.email.accept(email)
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
    
    private func getUserEmail() -> Observable<String> {
        return userRepository.getUserEmail()
    }
    
    private func logout() {
        print("로그아웃 로직 구현")
    }
}

