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
} 
