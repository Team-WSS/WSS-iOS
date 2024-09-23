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
    
    func postFeedComment(feedId: Int) -> Single<FeedCommentContent>
    func putFeedComment(feedId: Int, commentId: Int) -> Single<FeedCommentContent>
    func deleteFeedComment(feedId: Int, commentId: Int) -> Single<Void>
}

final class DefaultFeedDetailService: NSObject, Networking, FeedDetailService {
    private var urlSession: URLSession = URLSession(configuration: URLSessionConfiguration.default,
                                                    delegate: nil,
                                                    delegateQueue: nil)
    
    func getFeed(feedId: Int) -> Single<Feed> {
        do {
            let request = try makeHTTPRequest(method: .get,
                                              path: URLs.Feed.getSingleFeed(feedId: feedId),
                                              headers: APIConstants.testTokenHeader,
                                              body: nil)
            
            NetworkLogger.log(request: request)
            
            return urlSession.rx.data(request: request)
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
                                              headers: APIConstants.testTokenHeader,
                                              body: nil)
            
            NetworkLogger.log(request: request)
            
            return urlSession.rx.data(request: request)
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
                                              headers: APIConstants.testTokenHeader,
                                              body: nil)
            
            NetworkLogger.log(request: request)
            
            return urlSession.rx.data(request: request)
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
                                              headers: APIConstants.testTokenHeader,
                                              body: nil)
            
            NetworkLogger.log(request: request)
            
            return urlSession.rx.data(request: request)
                .map { _ in }
                .asSingle()
            
        } catch {
            return Single.error(error)
        }
    }
    
    func postFeedComment(feedId: Int) -> Single<FeedCommentContent> {
        do {
            let request = try makeHTTPRequest(method: .delete,
                                              path: URLs.Feed.postComment(feedId: feedId),
                                              headers: APIConstants.testTokenHeader,
                                              body: nil)
            
            NetworkLogger.log(request: request)
            
            return urlSession.rx.data(request: request)
                .map { try self.decode(data: $0,
                                       to: FeedCommentContent.self) }
                .asSingle()
            
        } catch {
            return Single.error(error)
        }
    }
    
    func putFeedComment(feedId: Int, commentId: Int) -> Single<FeedCommentContent> {
        do {
            let request = try makeHTTPRequest(method: .delete,
                                              path: URLs.Feed.putComment(feedId: feedId, commentId: commentId),
                                              headers: APIConstants.testTokenHeader,
                                              body: nil)
            
            NetworkLogger.log(request: request)
            
            return urlSession.rx.data(request: request)
                .map { try self.decode(data: $0,
                                       to: FeedCommentContent.self) }
                .asSingle()
            
        } catch {
            return Single.error(error)
        }
    }
    
    func deleteFeedComment(feedId: Int, commentId: Int) -> Single<Void> {
        do {
            let request = try makeHTTPRequest(method: .delete,
                                              path: URLs.Feed.deleteComment(feedId: feedId, commentId: commentId),
                                              headers: APIConstants.testTokenHeader,
                                              body: nil)
            
            NetworkLogger.log(request: request)
            
            return urlSession.rx.data(request: request)
                .map { _ in }
                .asSingle()
            
        } catch {
            return Single.error(error)
        }
    }
}
