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
    func patchUserName(userNickName: String) -> Observable<Void>
    func getUserCharacter() -> Observable<UserCharacter>
    func getUserProfileVisibility() -> Observable<UserProfileVisibility>
    func patchUserProfileVisibility(isProfilePublic: Bool) -> Observable<Void>
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
    
    func patchUserName(userNickName: String) -> RxSwift.Observable<Void> {
        return userService.patchUserName(userNickName: userNickName)
            .asObservable()
    }
    
    func getUserCharacter() -> Observable<UserCharacter> {
        return userService.getUserCharacterData()
            .asObservable()
    }
    
    func getUserProfileVisibility() -> Observable<UserProfileVisibility> {
        return userService.getUserProfileVisibility()
            .asObservable()
    }
    
    func patchUserProfileVisibility(isProfilePublic: Bool) -> Observable<Void> {
        return userService.patchUserProfileVisibility(isProfilePublic: isProfilePublic)
            .asObservable()
    }
}
