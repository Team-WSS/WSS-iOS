//
//  UserNovelRepository.swift
//  WSSiOS
//
//  Created by 최서연 on 1/14/24.
//

import Foundation

import RxSwift

protocol UserNovelRepository {
    func getUserNovelList(readStatus: String,
                          lastUserNovelId: Int,
                          size: Int,
                          sortType: String) -> Observable<UserNovelList>
    func getUserNovel(userNovelId: Int) -> Observable<UserNovelDetail>
    func deleteUserNovel(userNovelId: Int) -> Observable<Void>
    func postUserNovel(novelId: Int, userNovelRating: Float?, userNovelReadStatus: ReadStatus, userNovelReadStartDate: String?, userNovelReadEndDate: String?) -> Observable<UserNovelId>
    func patchUserNovel(userNovelId: Int, userNovelRating: Float?, userNovelReadStatus: ReadStatus, userNovelReadStartDate: String?, userNovelReadEndDate: String?) -> Observable<Void>
}

struct DefaultUserNovelRepository: UserNovelRepository {
    private var userNovelService: UserNovelService
    
    init(userNovelService: UserNovelService) {
        self.userNovelService = userNovelService
    }
    
    func getUserNovelList(readStatus: String, lastUserNovelId: Int, size: Int, sortType: String) -> RxSwift.Observable<UserNovelList> {
        return userNovelService.getUserNovelList(readStatus: readStatus,
                                                 lastUserNovelId: lastUserNovelId,
                                                 size: size,
                                                 sortType: sortType)
        .asObservable()
    }
    
    func getUserNovel(userNovelId: Int) -> Observable<UserNovelDetail> {
        return userNovelService.getUserNovel(userNovelId: userNovelId)
            .asObservable()
    }
    
    func deleteUserNovel(userNovelId: Int) -> Observable<Void> {
        return userNovelService.deleteUserNovel(userNovelId: userNovelId)
            .asObservable()
    }
    
    func postUserNovel(novelId: Int, userNovelRating: Float?, userNovelReadStatus: ReadStatus, userNovelReadStartDate: String?, userNovelReadEndDate: String?) -> Observable<UserNovelId> {
        return userNovelService
            .postUserNovel(novelId: novelId,
                              userNovelRating: userNovelRating,
                              userNovelReadStatus: userNovelReadStatus,
                              userNovelReadStartDate: userNovelReadStartDate,
                              userNovelReadEndDate: userNovelReadEndDate
            ).asObservable()
    }
    
    func patchUserNovel(userNovelId: Int, userNovelRating: Float?, userNovelReadStatus: ReadStatus, userNovelReadStartDate: String?, userNovelReadEndDate: String?) -> Observable<Void> {
        return userNovelService
            .patchUserNovel(userNovelId: userNovelId,
                              userNovelRating: userNovelRating,
                              userNovelReadStatus: userNovelReadStatus,
                              userNovelReadStartDate: userNovelReadStartDate,
                              userNovelReadEndDate: userNovelReadEndDate
            ).asObservable()
    }
}
