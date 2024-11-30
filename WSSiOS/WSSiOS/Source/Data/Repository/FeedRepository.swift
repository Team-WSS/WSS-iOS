//
//  FeedRepository.swift
//  WSSiOS
//
//  Created by 신지원 on 5/15/24.
//

import Foundation

import RxSwift

protocol FeedRepository {
    func getFeedData(category: String,
                     lastFeedId: Int,
                     size: Int?) -> Observable<TotalFeed>
    func postFeed(relevantCategories: [String], feedContent: String, novelId: Int?, isSpoiler: Bool) -> Observable<Void>
    func putFeed(feedId: Int, relevantCategories: [String], feedContent: String, novelId: Int?, isSpoiler: Bool) -> Observable<Void>
}

struct DefaultFeedRepository: FeedRepository {
    private var feedService: FeedService
    private let size = 20
    
    init(feedService: FeedService) {
        self.feedService = feedService
    }
    
    func getFeedData(category: String, lastFeedId: Int, size: Int?) -> RxSwift.Observable<TotalFeed> {
        return feedService.getFeedList(category: category, lastFeedId: lastFeedId, size: size ?? self.size)
            .asObservable()
    }
   
    func postFeed(relevantCategories: [String], feedContent: String, novelId: Int?, isSpoiler: Bool) -> Observable<Void> {
        return feedService.postFeed(relevantCategories: relevantCategories, feedContent: feedContent, novelId: novelId, isSpoiler: isSpoiler)
            .asObservable()
    }
    
    func putFeed(feedId: Int, relevantCategories: [String], feedContent: String, novelId: Int?, isSpoiler: Bool) -> Observable<Void> {
        return feedService.putFeed(feedId: feedId, relevantCategories: relevantCategories, feedContent: feedContent, novelId: novelId, isSpoiler: isSpoiler)
            .asObservable()
    }
    
}
