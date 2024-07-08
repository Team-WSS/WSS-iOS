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
    func getSingleFeedData() -> Observable<Feed>
    func getSingleFeedComments() -> Observable<[Comment]>
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
    
    func getSingleFeedData() -> Observable<Feed> {
        return Observable.just(Feed(userProfileImage: "imgTest2",
                                    userNickName: "구리구리스",
                                    createdDate: "10월 3일",
                                    content: "짱짱걸",
                                    novelTitle: "여주가 세계를 구한다",
                                    novelRating: 4.21,
                                    novelRatingCount: 123,
                                    genres: [.bl, .drama],
                                    likeCount: 12,
                                    commentCount: 56,
                                    isLiked: true))
    }
    
    func getSingleFeedComments() -> Observable<[Comment]> {
        return Observable.just(
            [Comment(userId: 1,
                     userNickname: "구리스",
                     userProfileImage: "imgTest2",
                     commentId: 1,
                     createdDate: "10월 3일",
                     commentContent: "진짜 재미있다 ㄷㄷ",
                     isModified: true,
                     isMyComment: true),
             Comment(userId: 1,
                     userNickname: "이진토",
                     userProfileImage: "imgTest2",
                     commentId: 1,
                     createdDate: "11월 16일",
                     commentContent: "진짜 더 재미있다 ㄷㄷ",
                     isModified: false,
                     isMyComment: false),
             Comment(userId: 1,
                     userNickname: "이안",
                     userProfileImage: "imgTest2",
                     commentId: 1,
                     createdDate: "7월 10일",
                     commentContent: "진짜진짜 재미있다!",
                     isModified: true,
                     isMyComment: false)
            ])
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
    
    func getSingleFeedData() -> Observable<Feed> {
        return Observable.just(Feed(userProfileImage: "imgTest2", userNickName: "구리구리스", createdDate: "10월 3일", content: "짱짱걸", novelTitle: "여주가 세계를 구한다고라고라", novelRating: 4.21, novelRatingCount: 123, genres: [.bl, .drama], likeCount: 12, commentCount: 23, isLiked: true))
    }
    
    func getSingleFeedComments() -> Observable<[Comment]> {
        return Observable.just(
            [Comment(userId: 1,
                     userNickname: "구리스",
                     userProfileImage: "imgTest2",
                     commentId: 1,
                     createdDate: "10월 3일",
                     commentContent: "진짜 재미있다 ㄷㄷ",
                     isModified: false,
                     isMyComment: true),
             Comment(userId: 1,
                     userNickname: "이진토",
                     userProfileImage: "imgTest2",
                     commentId: 1,
                     createdDate: "11월 16일",
                     commentContent: "진짜 더 재미있다 ㄷㄷ",
                     isModified: true,
                     isMyComment: false),
             Comment(userId: 1,
                     userNickname: "이안",
                     userProfileImage: "imgTest2",
                     commentId: 1,
                     createdDate: "7월 10일",
                     commentContent: "진짜진짜 재미있다!",
                     isModified: true,
                     isMyComment: false)
            ])
    }
}
