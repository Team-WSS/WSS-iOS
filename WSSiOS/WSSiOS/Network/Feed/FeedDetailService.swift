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
    
}
