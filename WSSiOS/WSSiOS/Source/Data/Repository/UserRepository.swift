//
//  UserRepository.swift
//  WSSiOS
//
//  Created by 신지원 on 1/5/24.
//

import Foundation

import RxSwift

protocol UserRepository {
    func getUserMeData() -> Observable<UserMeResult>
    func getMyProfileData() -> Observable<MyProfileResult>
    func getOtherProfile(userId: Int) -> Observable<OtherProfileResult>
    func getUserInfo() -> Observable<UserInfo>
    func putUserInfo(gender: String, birth: Int) -> Observable<Void>
    func patchUserName(userNickName: String) -> Observable<Void>
    func getBlocksList() -> Observable<BlockUserResult>
    func deleteBlockUser(blockID: Int) -> Observable<Void>
    func getUserProfileVisibility() -> Observable<UserProfileVisibility>
    func patchUserProfileVisibility(isProfilePublic: Bool) -> Observable<Void>
    func getUserNovelStatus(userId: Int) -> Observable<UserNovelStatus>
    func getUserNovelPreferences(userId: Int) -> Observable<UserNovelPreferences>
    func getUserGenrePreferences(userId: Int) -> Observable<UserGenrePreferences>
    func postBlockUser(userId: Int) -> Observable<Void>
    func patchUserProfile(updatedFields: [String: Any]) -> Observable<Void>
    func getNicknameisValid(nickname: String) -> Single<OnboardingResult>
}

struct DefaultUserRepository: UserRepository {
    private var userService: UserService
    private var blocksService: BlocksService
    
    init(userService: UserService, blocksService: BlocksService) {
        self.userService = userService
        self.blocksService = blocksService
    }
    
    func getUserMeData() -> Observable<UserMeResult> {
        return userService.getUserData()
            .asObservable()
    }
    
    func getMyProfileData() -> Observable<MyProfileResult> {
        return userService.getMyProfile()
            .asObservable()
    }
    
    func getOtherProfile(userId: Int) -> Observable<OtherProfileResult> {
        return userService.getOtherProfile(userId: userId)
            .asObservable()
    }
    
    func getUserData() -> Observable<UserMeResult> {
        return userService.getUserData()
            .asObservable()
    }
    
    func getUserInfo() -> Observable<UserInfo> {
        return userService.getUserInfo()
            .asObservable()
    }
    
    func putUserInfo(gender: String, birth: Int) -> Observable<Void> {
        return userService.putUserInfo(gender: gender, birth: birth)
            .asObservable()
    }
    
    func patchUserName(userNickName: String) -> Observable<Void> {
        return userService.patchUserName(userNickName: userNickName)
            .asObservable()
    }
    
    func getBlocksList() -> Observable<BlockUserResult> {
        return blocksService.getBlocksList()
            .asObservable()
    }
    
    func deleteBlockUser(blockID: Int) -> Observable<Void> {
        return blocksService.deleteBlockUser(blockID: blockID)
            .asObservable()
    }
    
    func getUserNovelStatus(userId: Int) -> Observable<UserNovelStatus> {
        return userService.getUserNovelStatus(userId: userId)
            .asObservable()
    }
    
    func getUserNovelPreferences(userId: Int) -> Observable<UserNovelPreferences> {
        return userService.getUserNovelPreferences(userId: userId)
            .asObservable()
    }
    
    func getUserGenrePreferences(userId: Int) -> Observable<UserGenrePreferences> {
        return userService.getUserGenrePreferences(userId: userId)
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
    
    func postBlockUser(userId: Int) -> Observable<Void> {
        return blocksService.postBlockUser(blockID: userId)
            .asObservable()
    }
    func patchUserProfile(updatedFields: [String: Any]) -> Observable<Void> {
        return userService.patchUserProfile(updatedFields: updatedFields)
            .asObservable()
    }
    
    func getNicknameisValid(nickname: String) -> Single<OnboardingResult> {
        return userService.getNicknameisValid(nickname: nickname)
    }
}
