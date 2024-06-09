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
                     size: Int) -> Observable<TotalFeed>
}

struct DefaultFeedRepository: FeedRepository {
    private var feedService: FeedService

    init(feedService: FeedService) {
        self.feedService = feedService
    }

    func getFeedData(category: String, lastFeedId: Int, size: Int) -> RxSwift.Observable<TotalFeed> {
        return feedService.getFeedList(category: category, lastFeedId: lastFeedId, size: size)
        .asObservable()
    }
}
