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
    func postFeed(relevantCategories: [String], feedContent: String, novelId: Int?, isSpoiler: Bool) -> Observable<Void>
    func putFeed(feedId: Int, relevantCategories: [String], feedContent: String, novelId: Int?, isSpoiler: Bool) -> Observable<Void>
}

struct TestFeedRepository: FeedRepository {
    func getFeedData(category: String, lastFeedId: Int, size: Int) -> Observable<TotalFeed> {
        return Observable.just(TotalFeed(category: "drama", isLoadable: true, feeds: [TotalFeeds(userId: 123,
                                                                                                 nickname: "지원입니둥",
                                                                                                 avatarImage: dummyFeedImage,
                                                                                                 feedId: 846,
                                                                                                 createdDate: "3월 21일",
                                                                                                 feedContent: "판소추천해요!",
                                                                                                 likeCount: 333,
                                                                                                 isLiked: false,
                                                                                                 commentCount: 7,
                                                                                                 novelId: 123,
                                                                                                 title: "안녕하세요전안안녕한데요?안녕하세요?안녕하신지요?",
                                                                                                 novelRatingCount: 523,
                                                                                                 novelRating: 4.0,
                                                                                                 relevantCategories: ["wuxia", "romance", "wuxia", "romance"],
                                                                                                 isSpolier: false,
                                                                                                 isModified: true,
                                                                                                 isMyFeed: false)]))
    }
    
    func postFeed(relevantCategories: [String], feedContent: String, novelId: Int?, isSpoiler: Bool) -> Observable<Void> {
        return Observable.just(())
    }
    
    func putFeed(feedId: Int, relevantCategories: [String], feedContent: String, novelId: Int?, isSpoiler: Bool) -> Observable<Void> {
        return Observable.just(())
    }
    
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
   
    func postFeed(relevantCategories: [String], feedContent: String, novelId: Int?, isSpoiler: Bool) -> Observable<Void> {
        return feedService.postFeed(relevantCategories: relevantCategories, feedContent: feedContent, novelId: novelId, isSpoiler: isSpoiler)
            .asObservable()
    }
    
    func putFeed(feedId: Int, relevantCategories: [String], feedContent: String, novelId: Int?, isSpoiler: Bool) -> Observable<Void> {
        return feedService.putFeed(feedId: feedId, relevantCategories: relevantCategories, feedContent: feedContent, novelId: novelId, isSpoiler: isSpoiler)
            .asObservable()
    }
    
}
