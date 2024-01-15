//
//  UserAPI.swift
//  WSSiOS
//
//  Created by 최서연 on 1/14/24.
//

import UIKit

import RxSwift
import RxCocoa

final class DefaultMyUseCase: MyUseCase {
    
    private let userRepository: UserRepository
    private let disposeBag = DisposeBag()
    
    init(
        userRepository: UserRepository
    ) {
        self.userRepository = userRepository
    }
    
    var profileData = PublishRelay<UserDTO>()
}

extension DefaultMyUseCase {
    func requestMyPage() {
        userRepository.getUserData()
            .subscribe(with: self, onNext: { owner, pet in
                owner.profileData.accept(pet)
            }).disposed(by: disposeBag)
    }
}

