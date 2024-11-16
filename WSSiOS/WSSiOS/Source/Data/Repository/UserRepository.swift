//
//  UserRepository.swift
//  WSSiOS
//
//  Created by 신지원 on 1/5/24.
//

import Foundation

import RxSwift

protocol UserRepository {
    func getMyProfileData() -> Observable<MyProfileResult>
    func getUserInfo() -> Observable<UserInfo>
    func putUserInfo(gender: String, birth: Int) -> Observable<Void>
    func patchUserName(userNickName: String) -> Observable<Void>
    func getUserCharacter() -> Observable<UserCharacter>
    func getBlocksList() -> Observable<BlockUserResult>
    func deleteBlockUser(blockID: Int) -> Observable<Void>
    func getUserNovelStatus(userId: Int) -> Observable<UserNovelStatus>
    func getUserNovelPreferences(userId: Int) -> Observable<UserNovelPreferences>
    func getUserGenrePreferences(userId: Int) -> Observable<UserGenrePreferences>
}

struct DefaultUserRepository: UserRepository {
    private var userService: UserService
    private var blocksService: BlocksService
    
    init(userService: UserService, blocksService: BlocksService) {
        self.userService = userService
        self.blocksService = blocksService
    }
    
    func getMyProfileData() -> Observable<MyProfileResult> {
        return userService.getMyProfile()
            .asObservable()
    }
    
    func getUserData() -> RxSwift.Observable<UserResult> {
        return userService.getUserData()
            .asObservable()
    }
    
    func getUserInfo() -> RxSwift.Observable<UserInfo> {
        return userService.getUserInfo()
            .asObservable()
    }
    
    func putUserInfo(gender: String, birth: Int) -> RxSwift.Observable<Void> {
        return userService.putUserInfo(gender: gender, birth: birth)
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
    
    func getBlocksList() -> RxSwift.Observable<BlockUserResult> {
        return blocksService.getBlocksList()
            .asObservable()
    }
    
    func deleteBlockUser(blockID: Int) -> RxSwift.Observable<Void> {
        return blocksService.deleteBlockUser(blockID: blockID)
            .asObservable()
    }
    
    func getUserNovelStatus(userId: Int) -> RxSwift.Observable<UserNovelStatus> {
        return userService.getUserNovelStatus(userId: userId)
            .asObservable()
    }
    
    func getUserNovelPreferences(userId: Int) -> RxSwift.Observable<UserNovelPreferences> {
        return userService.getUserNovelPreferences(userId: userId)
            .asObservable()
    }
    
    func getUserGenrePreferences(userId: Int) -> RxSwift.Observable<UserGenrePreferences> {
        return userService.getUserGenrePreferences(userId: userId)
            .asObservable()
    }
}
