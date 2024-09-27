//
//  DetailRepository.swift
//  WSSiOS
//
//  Created by 이윤학 on 4/25/24.
//

import Foundation

import RxSwift

protocol NovelDetailRepository {
    func getNovelDetailHeaderData(novelId: Int) -> Observable<NovelDetailHeaderEntity>
    func getNovelDetailInfoData(novelId: Int) -> Observable<NovelDetailInfoResult>
    func getNovelDetailFeedData(novelId: Int, lastFeedId: Int) -> Observable<NovelDetailFeedResult>
    func postUserInterest(novelId: Int) -> Observable<Void>
    func deleteUserInterest(novelId: Int) -> Observable<Void>
    func deleteNovelReview(novelId: Int) -> Observable<Void>
}

struct TestNovelDetailRepository: NovelDetailRepository {
    func deleteNovelReview(novelId: Int) -> Observable<Void> {
        return Observable.just(())
    }
    
    func postUserInterest(novelId: Int) -> Observable<Void> {
        return Observable.just(())
    }
    
    func deleteUserInterest(novelId: Int) -> Observable<Void> {
        return Observable.just(())
    }
    
    func getNovelDetailHeaderData(novelId: Int) -> Observable<NovelDetailHeaderEntity> {
        return Observable.just(NovelDetailHeaderResult.dummyFullData[0]).flatMap { $0.transform() }
    }
    
    func getNovelDetailInfoData(novelId: Int) -> Observable<NovelDetailInfoResult> {
        return Observable.just(NovelDetailInfoResult.dummyFullData[0])
    }
    
    func getNovelDetailFeedData(novelId: Int, lastFeedId: Int) -> Observable<NovelDetailFeedResult> {
        return Observable.just(NovelDetailFeedResult.dummyData)
    }
}

struct DefaultNovelDetailRepository {
    private let novelDetailService: NovelDetailService
    private let novelDetailFeedSize = 20

    init(novelDetailService: NovelDetailService) {
        self.novelDetailService = novelDetailService
    }
}

extension DefaultNovelDetailRepository: NovelDetailRepository  {
    func getNovelDetailHeaderData(novelId: Int) -> Observable<NovelDetailHeaderEntity> {
        return novelDetailService.getNovelDetailHeaderData(novelId: novelId).asObservable().flatMap{ $0.transform() }
    }
    
    func getNovelDetailInfoData(novelId: Int) -> Observable<NovelDetailInfoResult> {
        return novelDetailService.getNovelDetailInfoData(novelId: novelId).asObservable()
    }
    
    func getNovelDetailFeedData(novelId: Int, lastFeedId: Int) -> Observable<NovelDetailFeedResult> {
        return novelDetailService.getNovelDetailFeedData(novelId: novelId, lastFeedId: lastFeedId, size: novelDetailFeedSize).asObservable()
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

