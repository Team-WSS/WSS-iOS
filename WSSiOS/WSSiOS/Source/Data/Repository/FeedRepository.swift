//
//  FeedRepository.swift
//  WSSiOS
//
//  Created by 신지원 on 5/15/24.
//

import UIKit

import RxSwift

protocol FeedRepository {
    func getFeedData(category: String, lastFeedId: Int, size: Int?, feedsOption: String) -> Observable<TotalFeedListEntity>
    func postFeed(relevantCategories: [String], feedContent: String, novelId: Int?, isSpoiler: Bool, isPublic: Bool, images: [UIImage]) -> Observable<Void>
    func putFeed(feedId: Int, relevantCategories: [String], feedContent: String, novelId: Int?, isSpoiler: Bool, isPublic: Bool, images: [UIImage]) -> Observable<Void>
}

struct TestFeedRepository: FeedRepository {
    func getFeedData(category: String, lastFeedId: Int, size: Int?, feedsOption: String) -> Observable<TotalFeedListEntity> {
        return Observable.just(TotalFeedListEntity.dummyFullData)
    }
    
    func postFeed(relevantCategories: [String], feedContent: String, novelId: Int?, isSpoiler: Bool, isPublic: Bool, images: [UIImage]) -> Observable<Void> {
        return Observable.just(())
    }
    
    func putFeed(feedId: Int, relevantCategories: [String], feedContent: String, novelId: Int?, isSpoiler: Bool, isPublic: Bool, images: [UIImage]) -> Observable<Void> {
        return Observable.just(())
    }
}

struct DefaultFeedRepository: FeedRepository {
    private var feedService: FeedService
    private let size = 20
    
    init(feedService: FeedService) {
        self.feedService = feedService
    }
    
    func getFeedData(category: String, lastFeedId: Int, size: Int?, feedsOption: String) -> Observable<TotalFeedListEntity> {
        return feedService.getFeedList(category: category, lastFeedId: lastFeedId, size: size ?? self.size, feedsOption: feedsOption)
            .map { $0.toEntity()}
            .asObservable()
    }
    
    func postFeed(relevantCategories: [String], feedContent: String, novelId: Int?, isSpoiler: Bool, isPublic: Bool, images: [UIImage]) -> Observable<Void> {
        return feedService.postFeed(relevantCategories: relevantCategories, feedContent: feedContent, novelId: novelId, isSpoiler: isSpoiler, isPublic: isPublic, images: images)
            .asObservable()
    }
    
    func putFeed(feedId: Int, relevantCategories: [String], feedContent: String, novelId: Int?, isSpoiler: Bool, isPublic: Bool, images: [UIImage]) -> Observable<Void> {
        return feedService.putFeed(feedId: feedId, relevantCategories: relevantCategories, feedContent: feedContent, novelId: novelId, isSpoiler: isSpoiler, isPublic: isPublic, images: images)
            .asObservable()
    }
    
}
