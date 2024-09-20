//
//  MyPageChangeUserInfoViewModel.swift
//  WSSiOS
//
//  Created by 신지원 on 9/20/24.
//

import Foundation

import RxSwift
import RxCocoa

final class MyPageChangeUserInfoViewModel: ViewModelType {
    
    //MARK: - Properties
    
    private let userRepository: UserRepository

    //MARK: - Life Cycle
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    struct Input {
    
    }
    
    struct Output {
        let email = BehaviorRelay(value: "")
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
       
        return output
    }
    
    //MARK: - API
    
}

