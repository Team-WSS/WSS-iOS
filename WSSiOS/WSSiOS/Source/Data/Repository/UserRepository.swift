//
//  UserRepository.swift
//  WSSiOS
//
//  Created by 신지원 on 1/5/24.
//

import Foundation

import RxSwift

protocol UserRepository {
    func getUserData() -> Observable<UserResult>
}

struct DefaultUserRepository: UserRepository {
    
    private var userService: UserService
    
    init(userService: UserService) {
        self.userService = userService
    }
    
    func getUserData() -> RxSwift.Observable<UserResult> {
        return userService.getUserData()
            .asObservable()
    }
}
