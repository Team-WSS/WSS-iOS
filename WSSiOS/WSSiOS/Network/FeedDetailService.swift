//
//  FeedDetailService.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 9/22/24.
//

import Foundation

import RxSwift

protocol FeedDetailService {
    func getFeed(feedId: Int) -> Single<Feed>
    func getFeedComments(feedId: Int) -> Single<FeedComments>
    func postFeedLike(feedId: Int) -> Single<Void>
    func deleteFeedLike(feedId: Int) -> Single<Void>
    
    func postComment(feedId: Int, commentContent: String) -> Single<Void>
    func putComment(feedId: Int, commentId: Int, commentContent: String) -> Single<Void>
    func deleteComment(feedId: Int, commentId: Int) -> Single<Void>
    
    func postSpoilerFeed(feedId: Int) -> Single<Void>
    func postImpertinenceFeed(feedId: Int) -> Single<Void>
    
    func deleteFeed(feedId: Int) -> Single<Void>
    
    func postSpoilerComment(feedId: Int, commentId: Int) -> Single<Void>
    func postImpertinenceComment(feedId: Int, commentId: Int) -> Single<Void>
}

final class DefaultFeedDetailService: NSObject, Networking, FeedDetailService {
    func getFeed(feedId: Int) -> Single<Feed> {
        do {
            let request = try makeHTTPRequest(method: .get,
                                              path: URLs.Feed.getSingleFeed(feedId: feedId),
                                              headers: APIConstants.accessTokenHeader,
                                              body: nil)
            
            NetworkLogger.log(request: request)
            
            return tokenCheckURLSession.rx.data(request: request)
                .map { try self.decode(data: $0,
                                       to: Feed.self) }
                .asSingle()
            
        } catch {
            return Single.error(error)
        }
    }
    
    func getFeedComments(feedId: Int) -> Single<FeedComments> {
        do {
            let request = try makeHTTPRequest(method: .get,
                                              path: URLs.Feed.getSingleFeedComments(feedId: feedId),
                                              headers: APIConstants.accessTokenHeader,
                                              body: nil)
            
            NetworkLogger.log(request: request)
            
            return tokenCheckURLSession.rx.data(request: request)
                .map { try self.decode(data: $0,
                                       to: FeedComments.self) }
                .asSingle()
            
        } catch {
            return Single.error(error)
        }
    }
    
    func postFeedLike(feedId: Int) -> Single<Void> {
        do {
            let request = try makeHTTPRequest(method: .post,
                                              path: URLs.Feed.postFeedLike(feedId: feedId),
                                              headers: APIConstants.accessTokenHeader,
                                              body: nil)
            
            NetworkLogger.log(request: request)
            
            return tokenCheckURLSession.rx.data(request: request)
                .map { _ in }
                .asSingle()
            
        } catch {
            return Single.error(error)
        }
    }
    
    func deleteFeedLike(feedId: Int) -> Single<Void> {
        do {
            let request = try makeHTTPRequest(method: .delete,
                                              path: URLs.Feed.deleteFeedLike(feedId: feedId),
                                              headers: APIConstants.accessTokenHeader,
                                              body: nil)
            
            NetworkLogger.log(request: request)
            
            return tokenCheckURLSession.rx.data(request: request)
                .map { _ in }
                .asSingle()
            
        } catch {
            return Single.error(error)
        }
    }
    
    func postComment(feedId: Int, commentContent: String) -> Single<Void> {
        guard let commentContent = try? JSONEncoder().encode(FeedCommentContent(commentContent: commentContent)) else {
            return Single.error(NetworkServiceError.invalidRequestError)
        }
        
        do {
            let request = try makeHTTPRequest(method: .post,
                                              path: URLs.Feed.postComment(feedId: feedId),
                                              headers: APIConstants.accessTokenHeader,
                                              body: commentContent)
            
            NetworkLogger.log(request: request)
            
            return tokenCheckURLSession.rx.data(request: request)
                .map { _ in }
                .asSingle()
            
        } catch {
            return Single.error(error)
        }
    }
    
    func putComment(feedId: Int, commentId: Int, commentContent: String) -> Single<Void> {
        guard let commentContent = try? JSONEncoder().encode(FeedCommentContent(commentContent: commentContent)) else {
            return Single.error(NetworkServiceError.invalidRequestError)
        }
        
        do {
            let request = try makeHTTPRequest(method: .put,
                                              path: URLs.Feed.putComment(feedId: feedId, commentId: commentId),
                                              headers: APIConstants.accessTokenHeader,
                                              body: commentContent)
            
            NetworkLogger.log(request: request)
            
            return tokenCheckURLSession.rx.data(request: request)
                .map { _ in }
                .asSingle()
            
        } catch {
            return Single.error(error)
        }
    }
    
    func deleteComment(feedId: Int, commentId: Int) -> Single<Void> {
        do {
            let request = try makeHTTPRequest(method: .delete,
                                              path: URLs.Feed.deleteComment(feedId: feedId, commentId: commentId),
                                              headers: APIConstants.accessTokenHeader,
                                              body: nil)
            
            NetworkLogger.log(request: request)
            
            return tokenCheckURLSession.rx.data(request: request)
                .map { _ in }
                .asSingle()
            
        } catch {
            return Single.error(error)
        }
    }
    
    func postSpoilerFeed(feedId: Int) -> Single<Void> {
        do {
            let request = try makeHTTPRequest(method: .post,
                                              path: URLs.Feed.postSpoilerFeed(feedId: feedId),
                                              headers: APIConstants.accessTokenHeader,
                                              body: nil)
            
            NetworkLogger.log(request: request)
            
            return tokenCheckURLSession.rx.data(request: request)
                .map { _ in }
                .asSingle()
            
        } catch {
            return Single.error(error)
        }
    }
    
    func postImpertinenceFeed(feedId: Int) -> Single<Void> {
        do {
            let request = try makeHTTPRequest(method: .post,
                                              path: URLs.Feed.postImpertinenceFeed(feedId: feedId),
                                              headers: APIConstants.accessTokenHeader,
                                              body: nil)
            
            NetworkLogger.log(request: request)
            
            return tokenCheckURLSession.rx.data(request: request)
                .map { _ in }
                .asSingle()
            
        } catch {
            return Single.error(error)
        }
    }
    
    func deleteFeed(feedId: Int) -> Single<Void> {
        do {
            let request = try makeHTTPRequest(method: .delete,
                                              path: URLs.Feed.deleteFeed(feedId: feedId),
                                              headers: APIConstants.accessTokenHeader,
                                              body: nil)
            
            NetworkLogger.log(request: request)
            
            return tokenCheckURLSession.rx.data(request: request)
                .map { _ in }
                .asSingle()
            
        } catch {
            return Single.error(error)
        }
    }
    
    func postSpoilerComment(feedId: Int, commentId: Int) -> Single<Void> {
        do {
            let request = try makeHTTPRequest(method: .post,
                                              path: URLs.Feed.postSpoilerComment(feedId: feedId, commentId: commentId),
                                              headers: APIConstants.accessTokenHeader,
                                              body: nil)
            
            NetworkLogger.log(request: request)
            
            return tokenCheckURLSession.rx.data(request: request)
                .map { _ in }
                .asSingle()
            
        } catch {
            return Single.error(error)
        }
    }
    
    func postImpertinenceComment(feedId: Int, commentId: Int) -> Single<Void> {
        do {
            let request = try makeHTTPRequest(method: .post,
                                              path: URLs.Feed.postImpertinenceComment(feedId: feedId, commentId: commentId),
                                              headers: APIConstants.accessTokenHeader,
                                              body: nil)
            
            NetworkLogger.log(request: request)
            
            return tokenCheckURLSession.rx.data(request: request)
                .map { _ in }
                .asSingle()
            
        } catch {
            return Single.error(error)
        }
    }
}
