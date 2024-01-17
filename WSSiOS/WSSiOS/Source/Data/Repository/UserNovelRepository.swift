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
}
