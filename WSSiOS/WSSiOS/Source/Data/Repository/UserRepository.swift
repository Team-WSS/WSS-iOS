//
//  UserRepository.swift
//  WSSiOS
//
//  Created by 신지원 on 1/5/24.
//

import Foundation

import RxSwift

protocol UserRepository {
    func getUserCharacter() -> Observable<UserCharacter>
}

struct DefaultUserRepository: UserRepository {
    
    private var userService: UserService
    
    init(userService: UserService) {
        self.userService = userService
    }
    
    func getUserCharacter() -> Observable<UserCharacter> {
        return userService.getUserCharacterData()
            .asObservable()
    }
}
