//
//  FeedRepository.swift
//  WSSiOS
//
//  Created by 신지원 on 5/15/24.
//

import UIKit

import RxSwift

protocol FeedRepository {
    func getFeedData(lastFeedId: Int, size: Int?, feedsOption: String) -> Observable<TotalFeedListEntity>
    func postFeed(feedContent: String, novelId: Int?, isSpoiler: Bool, isPublic: Bool, images: [UIImage]) -> Observable<Void>
    func putFeed(feedId: Int, feedContent: String, novelId: Int?, isSpoiler: Bool, isPublic: Bool, images: [UIImage]) -> Observable<Void>
}

struct TestFeedRepository: FeedRepository {
    func getFeedData(lastFeedId: Int, size: Int?, feedsOption: String) -> Observable<TotalFeedListEntity> {
        return Observable.just(TotalFeedListEntity.dummyFullData)
    }
    
    func postFeed(feedContent: String, novelId: Int?, isSpoiler: Bool, isPublic: Bool, images: [UIImage]) -> Observable<Void> {
        return Observable.just(())
    }
    
    func putFeed(feedId: Int, feedContent: String, novelId: Int?, isSpoiler: Bool, isPublic: Bool, images: [UIImage]) -> Observable<Void> {
        return Observable.just(())
    }
}

struct DefaultFeedRepository: FeedRepository {
    private var feedService: FeedService
    private let size = 20
    
    init(feedService: FeedService) {
        self.feedService = feedService
    }
    
    func getFeedData(lastFeedId: Int, size: Int?, feedsOption: String) -> Observable<TotalFeedListEntity> {
        return feedService.getFeedList(lastFeedId: lastFeedId, size: size ?? self.size, feedsOption: feedsOption)
            .map { $0.toEntity()}
            .asObservable()
    }
    
    func postFeed(feedContent: String, novelId: Int?, isSpoiler: Bool, isPublic: Bool, images: [UIImage]) -> Observable<Void> {
        return feedService.postFeed(feedContent: feedContent, novelId: novelId, isSpoiler: isSpoiler, isPublic: isPublic, images: images)
            .asObservable()
    }
    
    func putFeed(feedId: Int, feedContent: String, novelId: Int?, isSpoiler: Bool, isPublic: Bool, images: [UIImage]) -> Observable<Void> {
        return feedService.putFeed(feedId: feedId, feedContent: feedContent, novelId: novelId, isSpoiler: isSpoiler, isPublic: isPublic, images: images)
            .asObservable()
    }
    
}
