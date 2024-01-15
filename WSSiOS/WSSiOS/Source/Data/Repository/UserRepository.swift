//
//  UserRepository.swift
//  WSSiOS
//
//  Created by 신지원 on 1/5/24.
//

import Foundation

import RxSwift

protocol UserRepository {
    func getUserData() -> Observable<UserDTO>
}

struct DefaultUserRepository: UserRepository {
    
    private var userService: UserService
    static let shared = DefaultUserRepository(userService: DefaultUserService())
    
    init(userService: UserService) {
        self.userService = userService
    }
    
    func getUserData() -> RxSwift.Observable<UserDTO> {
        return userService.getUserData()
            .asObservable()
    }
}
