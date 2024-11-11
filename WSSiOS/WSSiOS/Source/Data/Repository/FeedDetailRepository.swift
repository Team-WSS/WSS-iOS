//
//  FeedDetailRepository.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 9/22/24.
//

import UIKit

import RxSwift

protocol FeedDetailRepository {
    func getSingleFeedData(feedId: Int) -> Observable<Feed>
    func getSingleFeedComments(feedId: Int) -> Observable<FeedComments>
    
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
    func getSingleFeedData(feedId: Int) -> Observable<Feed> {
        return Observable.just(Feed(userId: 1003,
                                    userNickname: "구리스",
                                    userProfileImage: "https://i.pinimg.com/564x/d6/01/72/d60172b19b2a70f0e64282ac769cbe00.jpg",
                                    feedId: 1,
                                    createdDate: "10월 3일",
                                    feedContent: "여름 햇살이 뜨겁게 내리쬐던 어느 오후, 작은 마을의 공원에서 아이들의 웃음소리가 가득했다. 그들은 공놀이를 하며 즐거운 시간을 보내고 있었다. 나무 그늘 아래에는 노부부가 벤치에 앉아 이야기를 나누고 있었다. 그들은 서로의 손을 꼭 잡고 오랜 추억을 이야기하며 미소를 지었다. 공원의 풍경은 평화롭고 아름다웠다. 바람에 흔들리는 나뭇잎 소리와 함께 새들의 지저귐이 어우러져 한 폭의 그림 같았다. 시간이 천천히 흐르는 듯한 그곳에서, 사람들은 일상의 소소한 행복을 만끽하고 있었다.",
                                    likeCount: 123,
                                    isLiked: false,
                                    commentCount: 3,
                                    novelId: 1116,
                                    novelTitle: "결혼 다음날 남편이 사라졌다",
                                    novelRatingCount: 234,
                                    novelRating: 2.23,
                                    genres: ["drama", "modernFantasy", "romanceFantasy"],
                                    isSpoiler: false,
                                    isModified: true,
                                    isMyFeed: false)
        )
    }
    
    func getSingleFeedComments(feedId: Int) -> Observable<FeedComments> {
        return Observable.just(FeedComments(commentsCount: 0, comments: []))
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
    
    func getSingleFeedData(feedId: Int) -> Observable<Feed> {
        return feedDetailService.getFeed(feedId: feedId).asObservable()
    }
    
    func getSingleFeedComments(feedId: Int) -> Observable<FeedComments> {
        return feedDetailService.getFeedComments(feedId: feedId).asObservable()
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
