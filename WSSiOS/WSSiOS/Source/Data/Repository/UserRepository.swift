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
    func getUserEmail() -> Observable<String>
    func patchUserName(userNickName: String) -> Observable<Void>
    func getUserCharacter() -> Observable<UserCharacter>
    func getBlocksList() -> Observable<BlockUserResult>
    func deleteBlockUser(blockID: Int) -> Observable<Void>
}

struct DefaultUserRepository: UserRepository {
    func getMyProfileData() -> RxSwift.Observable<MyProfileResult> {
        return Observable.just(MyProfileResult(nickname: "밝보",
                                               intro: "꺄울 로판에 절여진 밝보입니다~꺄울 로판에 절여진 밝보입니다~꺄울 로판에",
                                               avatarImage: "https://mblogthumb-phinf.pstatic.net/MjAyMjAzMjlfMSAg/MDAxNjQ4NDgwNzgwMzkw.yDLPqC9ouJxYoJSgicANH0CPNvFdcixexP7hZaPlCl4g.n7yZDyGC06_gRTwEnAKIhj5bM04laVpNuKRz29dP83wg.JPEG.38qudehd/IMG_8635.JPG?type=w800",
                                               genrePreferences: ["romance", "fantasy", "wuxia"]))
    }
    
    
    private var userService: UserService
    private var blocksService: BlocksService
    
    init(userService: UserService, blocksService: BlocksService) {
        self.userService = userService
        self.blocksService = blocksService
    }
    
    func getUserData() -> RxSwift.Observable<UserResult> {
        return userService.getUserData()
            .asObservable()
    }
    
    func getUserEmail() -> RxSwift.Observable<String> {
        return Observable.just("shinjiwonZZang")
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
        let blockListData = [
            blockList(blockId: 0, userId: 0, nickname: "지원이", avatarImage: ""),
            blockList(blockId: 1, userId: 1, nickname: "지원이잉비나당", avatarImage: "avatar2")
        ]
        let blockUserResult = BlockUserResult(blocks: blockListData)
        return Observable.just(blockUserResult)
    }
    
    func deleteBlockUser(blockID: Int) -> RxSwift.Observable<Void> {
        return self.blocksService.deleteBlockUser(blockID: blockID).asObservable()
    }
}
