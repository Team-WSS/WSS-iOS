//
//  UserNovelRepository.swift
//  WSSiOS
//
//  Created by 최서연 on 1/14/24.
//

import Foundation

import RxSwift

protocol UserNovelRepository {
    func getUserNovel(userNovelId: Int) -> Observable<UserNovelDetail>
    func deleteUserNovel(userNovelId: Int) -> Observable<Void>
    func postUserNovel(novelId: Int, userNovelRating: Float?, userNovelReadStatus: ReadStatus, userNovelReadStartDate: String?, userNovelReadEndDate: String?) -> Observable<UserNovelId>
}

struct DefaultUserNovelRepository: UserNovelRepository {
    
    private var userNovelService: UserNovelService
    
    init(userNovelService: UserNovelService) {
        self.userNovelService = userNovelService
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
            .postUserNovelAPI(novelId: novelId,
                              userNovelRating: userNovelRating,
                              userNovelReadStatus: userNovelReadStatus,
                              userNovelReadStartDate: userNovelReadStartDate,
                              userNovelReadEndDate: userNovelReadEndDate
            ).asObservable()
    }
}
