//
//  FeedRepository.swift
//  WSSiOS
//
//  Created by 신지원 on 5/15/24.
//

import Foundation

import RxSwift

protocol FeedRepository {
    func getFeedData(category: String, lastFeedId: Int, size: Int?) -> Observable<TotalFeedListEntity>
    func postFeed(relevantCategories: [String], feedContent: String, novelId: Int?, isSpoiler: Bool, isPublic: Bool) -> Observable<Void>
    func putFeed(feedId: Int, relevantCategories: [String], feedContent: String, novelId: Int?, isSpoiler: Bool, isPublic: Bool) -> Observable<Void>
}

struct TestFeedRepository: FeedRepository {
    func getFeedData(category: String, lastFeedId: Int, size: Int?) -> Observable<TotalFeedListEntity> {
        return Observable.just(TotalFeedListEntity(category: "all",
                                                   isLoadable: true,
                                                   feeds: [
                                                    TotalFeedEntity(feedId: 10003,
                                                                    userId: 31313131,
                                                                    nickname: "최고다이순신",
                                                                    avatarImage: "",
                                                                    createdDate: "10월 4일",
                                                                    feedContent: "안녕 테스트 레포지토리야",
                                                                    likeCount: 12,
                                                                    isLiked: false,
                                                                    commentCount: 23,
                                                                    novelId: 234,
                                                                    title: "바보야",
                                                                    novelRatingCount: 23,
                                                                    novelRating: 3.33,
                                                                    relevantCategories: "없을걸",
                                                                    isSpoiler: false,
                                                                    isModified: false,
                                                                    isMyFeed: true,
                                                                    isPublic: true,
                                                                    thumbnailImage: "https://i.pinimg.com/736x/ec/af/63/ecaf63a83c5a37693a25b34f528aa9ad.jpg",
                                                                    hasImage: true,
                                                                    imageCount: 12),
                                                    TotalFeedEntity(feedId: 123123,
                                                                    userId: 31313131,
                                                                    nickname: "구리",
                                                                    avatarImage: "",
                                                                    createdDate: "10월 3일",
                                                                    feedContent: "이번엔 소설이 없고 이미지가 있어요",
                                                                    likeCount: 12,
                                                                    isLiked: false,
                                                                    commentCount: 23,
                                                                    novelId: -1,
                                                                    title: "",
                                                                    novelRatingCount: -1,
                                                                    novelRating: -1,
                                                                    relevantCategories: "없을걸",
                                                                    isSpoiler: false,
                                                                    isModified: false,
                                                                    isMyFeed: false,
                                                                    isPublic: true,
                                                                    thumbnailImage: "https://i.pinimg.com/736x/1a/51/98/1a5198477634dd2e194c02f3c8094b97.jpg",
                                                                    hasImage: true,
                                                                    imageCount: 3),
                                                    TotalFeedEntity(feedId: 123123,
                                                                    userId: 31313131,
                                                                    nickname: "구림",
                                                                    avatarImage: "",
                                                                    createdDate: "10월 3일",
                                                                    feedContent: "이번엔 이미지 없음",
                                                                    likeCount: 12,
                                                                    isLiked: false,
                                                                    commentCount: 23,
                                                                    novelId: 234,
                                                                    title: "바보야",
                                                                    novelRatingCount: 23,
                                                                    novelRating: 3.33,
                                                                    relevantCategories: "없을걸",
                                                                    isSpoiler: false,
                                                                    isModified: false,
                                                                    isMyFeed: false,
                                                                    isPublic: true,
                                                                    thumbnailImage: "https://i.pinimg.com/736x/38/7c/11/387c11814df12d9b28d64d0af942c679.jpg",
                                                                    hasImage: false,
                                                                    imageCount: 0),
                                                    TotalFeedEntity(feedId: 123123,
                                                                    userId: 31313131,
                                                                    nickname: "구리",
                                                                    avatarImage: "",
                                                                    createdDate: "10월 3일",
                                                                    feedContent: "이번엔 소설이 없군",
                                                                    likeCount: 12,
                                                                    isLiked: false,
                                                                    commentCount: 23,
                                                                    novelId: -1,
                                                                    title: "",
                                                                    novelRatingCount: -1,
                                                                    novelRating: -1,
                                                                    relevantCategories: "없을걸",
                                                                    isSpoiler: false,
                                                                    isModified: false,
                                                                    isMyFeed: false,
                                                                    isPublic: true,
                                                                    thumbnailImage: "https://i.pinimg.com/736x/5b/49/40/5b49408ec192cad6337b494b5ca4de38.jpg",
                                                                    hasImage: false,
                                                                    imageCount: 0)
                                                   ]))
    }
    
    func postFeed(relevantCategories: [String], feedContent: String, novelId: Int?, isSpoiler: Bool, isPublic: Bool) -> Observable<Void> {
        return Observable.just(())
    }
    
    func putFeed(feedId: Int, relevantCategories: [String], feedContent: String, novelId: Int?, isSpoiler: Bool, isPublic: Bool) -> Observable<Void> {
        return Observable.just(())
    }
}

struct DefaultFeedRepository: FeedRepository {
    private var feedService: FeedService
    private let size = 20
    
    init(feedService: FeedService) {
        self.feedService = feedService
    }
    
    func getFeedData(category: String, lastFeedId: Int, size: Int?) -> Observable<TotalFeedListEntity> {
        return feedService.getFeedList(category: category, lastFeedId: lastFeedId, size: size ?? self.size)
            .map { $0.toEntity()}
            .asObservable()
    }
    
    func postFeed(relevantCategories: [String], feedContent: String, novelId: Int?, isSpoiler: Bool, isPublic: Bool) -> Observable<Void> {
        return feedService.postFeed(relevantCategories: relevantCategories, feedContent: feedContent, novelId: novelId, isSpoiler: isSpoiler, isPublic: isPublic)
            .asObservable()
    }
    
    func putFeed(feedId: Int, relevantCategories: [String], feedContent: String, novelId: Int?, isSpoiler: Bool, isPublic: Bool) -> Observable<Void> {
        return feedService.putFeed(feedId: feedId, relevantCategories: relevantCategories, feedContent: feedContent, novelId: novelId, isSpoiler: isSpoiler, isPublic: isPublic)
            .asObservable()
    }
    
}
