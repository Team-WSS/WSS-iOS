//
//  FeedDetailRepository.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 9/22/24.
//

import UIKit

import RxSwift

protocol FeedDetailRepository {
    func getSingleFeedData(feedId: Int) -> Observable<FeedEntity>
    func getSingleFeedComments(feedId: Int) -> Observable<FeedCommentsEntity>
    
    func postFeedLike(feedId: Int) -> Observable<Void>
    func deleteFeedLike(feedId: Int) -> Observable<Void>
    
    func postComment(feedId: Int, commentContent: String) -> Observable<Void>
    func putComment(feedId: Int, commentId: Int, commentContent: String) -> Observable<Void>
    func deleteComment(feedId: Int, commentId: Int) -> Observable<Void>
    
    func postSpoilerFeed(feedId: Int) -> Observable<Void>
    func postImpertinenceFeed(feedId: Int) -> Observable<Void>
    
    func deleteFeed(feedId: Int) -> Observable<Void>
    
    func postSpoilerComment(feedId: Int, commentId: Int) -> Observable<Void>
    func postImpertinenceComment(feedId: Int, commentId: Int) -> Observable<Void>
}

struct TestFeedDetailRepository: FeedDetailRepository {
    func getSingleFeedData(feedId: Int) -> Observable<FeedEntity> {
        return Observable.just(FeedEntity(userId: 0, userNickname: "굴", userProfileImageURL: nil, feedId: 1, createdDate: "2001년 10월 3일", feedContent: "오호랏", likeCount: 1, isLiked: true, commentCount: 1, genreCategories: [], hasLinkedNovel: false, novelId: 1, novelTitle: "", novelRatingCount: 0, novelRating: 0, isSpoiler: false, isModified: true, isMyFeed: true))
    }
    
    func getSingleFeedComments(feedId: Int) -> Observable<FeedCommentsEntity> {
        return Observable.just(FeedCommentsEntity(commentsCount: 0, comments: []))
    }
    
    func postFeedLike(feedId: Int) -> Observable<Void> {
        return Observable.just(())
    }
    
    func deleteFeedLike(feedId: Int) -> Observable<Void> {
        return Observable.just(())
    }
    
    func postComment(feedId: Int, commentContent: String) -> Observable<Void> {
        return Observable.just(())
    }
    
    func putComment(feedId: Int, commentId: Int, commentContent: String) -> Observable<Void> {
        return Observable.just(())
    }
    
    func deleteComment(feedId: Int, commentId: Int) -> Observable<Void> {
        return Observable.just(())
    }
    
    func postSpoilerFeed(feedId: Int) -> Observable<Void> {
        return Observable.just(())
    }
    
    func postImpertinenceFeed(feedId: Int) -> Observable<Void> {
        return Observable.just(())
    }
    
    func deleteFeed(feedId: Int) -> Observable<Void> {
        return Observable.just(())
    }
    
    func postSpoilerComment(feedId: Int, commentId: Int) -> Observable<Void> {
        return Observable.just(())
    }
    
    func postImpertinenceComment(feedId: Int, commentId: Int) -> Observable<Void> {
        return Observable.just(())
    }
}

struct DefaultFeedDetailRepository: FeedDetailRepository {
    private var feedDetailService: FeedDetailService
    
    init(feedDetailService: FeedDetailService) {
        self.feedDetailService = feedDetailService
    }
    
    func getSingleFeedData(feedId: Int) -> Observable<FeedEntity> {
        return feedDetailService.getFeed(feedId: feedId)
            .map { $0.toEntity() }
            .asObservable()
    }
    
    func getSingleFeedComments(feedId: Int) -> Observable<FeedCommentsEntity> {
        return feedDetailService.getFeedComments(feedId: feedId)
            .map { $0.toEntity() }
            .asObservable()
    }
    
    func postFeedLike(feedId: Int) -> Observable<Void> {
        return feedDetailService.postFeedLike(feedId: feedId).asObservable()
    }
    
    func deleteFeedLike(feedId: Int) -> Observable<Void> {
        return feedDetailService.deleteFeedLike(feedId: feedId).asObservable()
    }
    
    func postComment(feedId: Int, commentContent: String) -> Observable<Void> {
        return feedDetailService.postComment(feedId: feedId, commentContent: commentContent).asObservable()
    }
    
    func putComment(feedId: Int, commentId: Int, commentContent: String) -> Observable<Void> {
        return feedDetailService.putComment(feedId: feedId, commentId: commentId, commentContent: commentContent).asObservable()
    }
    
    func deleteComment(feedId: Int, commentId: Int) -> Observable<Void> {
        return feedDetailService.deleteComment(feedId: feedId, commentId: commentId).asObservable()
    }
    
    func postSpoilerFeed(feedId: Int) -> Observable<Void> {
        return feedDetailService.postSpoilerFeed(feedId: feedId).asObservable()
    }
    
    func postImpertinenceFeed(feedId: Int) -> Observable<Void> {
        return feedDetailService.postImpertinenceFeed(feedId: feedId).asObservable()
    }
    
    func deleteFeed(feedId: Int) -> Observable<Void> {
        return feedDetailService.deleteFeed(feedId: feedId).asObservable()
    }
    
    func postSpoilerComment(feedId: Int, commentId: Int) -> Observable<Void> {
        return feedDetailService.postSpoilerComment(feedId: feedId, commentId: commentId).asObservable()
    }
    
    func postImpertinenceComment(feedId: Int, commentId: Int) -> Observable<Void> {
        return feedDetailService.postImpertinenceComment(feedId: feedId, commentId: commentId).asObservable()
    }
}
