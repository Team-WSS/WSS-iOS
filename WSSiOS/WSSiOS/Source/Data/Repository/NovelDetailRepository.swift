//
//  NovelDetailRepository.swift
//  WSSiOS
//
//  Created by 이윤학 on 4/25/24.
//

import Foundation

import RxSwift

protocol NovelDetailRepository {
    func getNovelDetailHeaderData(novelId: Int) -> Single<NovelDetailHeaderEntity>
    func getNovelDetailInfoData(novelId: Int) -> Observable<NovelDetailInfoResult>
    func getNovelDetailFeedData(novelId: Int,
                                lastFeedId: Int,
                                size: Int?) -> Observable<NovelDetailFeedResult>
    func postUserInterest(novelId: Int) -> Observable<Void>
    func deleteUserInterest(novelId: Int) -> Observable<Void>
    func deleteNovelReview(novelId: Int) -> Observable<Void>
}

struct DefaultNovelDetailRepository {
    private let novelDetailService: NovelDetailService
    private let novelDetailFeedSize = 20

    init(novelDetailService: NovelDetailService) {
        self.novelDetailService = novelDetailService
    }
}

extension DefaultNovelDetailRepository: NovelDetailRepository  {
    func getNovelDetailHeaderData(novelId: Int) -> Single<NovelDetailHeaderEntity> {
        return novelDetailService.getNovelDetailHeaderData(novelId: novelId).map { $0.toEntity() }
    }
    
    func getNovelDetailInfoData(novelId: Int) -> Observable<NovelDetailInfoResult> {
        return novelDetailService.getNovelDetailInfoData(novelId: novelId).asObservable()
    }
    
    func getNovelDetailFeedData(novelId: Int, lastFeedId: Int, size: Int?) -> Observable<NovelDetailFeedResult> {
        return novelDetailService.getNovelDetailFeedData(novelId: novelId, lastFeedId: lastFeedId, size: size ?? novelDetailFeedSize).asObservable()
    }
    
    func deleteNovelReview(novelId: Int) -> Observable<Void> {
        novelDetailService.deleteNovelReview(novelId: novelId).asObservable()
    }
    
    func postUserInterest(novelId: Int) -> Observable<Void> {
        return novelDetailService.postUserInterest(novelId: novelId).asObservable()
    }
    
    func deleteUserInterest(novelId: Int) -> Observable<Void> {
        return novelDetailService.deleteUserInterest(novelId: novelId).asObservable()
    }
}

