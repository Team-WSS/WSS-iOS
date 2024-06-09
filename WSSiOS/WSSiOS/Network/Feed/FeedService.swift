//
//  FeedService.swift
//  WSSiOS
//
//  Created by 신지원 on 6/3/24.
//

import Foundation

import RxSwift

protocol FeedService {
    func getFeedList(category: String,
                     lastFeedId: Int,
                     size: Int) -> Single<TotalFeed>
}

final class DefaultFeedService: NSObject, Networking, FeedService {
    func makeFeedListQuery(category: String,
                           lastFeedId: Int,
                           size: Int) -> [URLQueryItem] {
        return [
            URLQueryItem(name: "category", value: category),
            URLQueryItem(name: "lastFeedId", value: String(describing: lastFeedId)),
            URLQueryItem(name: "size", value: String(describing: size)),
        ]
    }

    private var urlSession: URLSession = URLSession(configuration: URLSessionConfiguration.default,
                                                    delegate: nil,
                                                    delegateQueue: nil)

    func getFeedList(category: String, lastFeedId: Int, size: Int) -> RxSwift.Single<TotalFeed> {
        do {
            let request = try makeHTTPRequest(method: .get,
                                              path: URLs.Feed.getFeeds,
                                              queryItems: makeFeedListQuery(category: category,
                                                                            lastFeedId: lastFeedId,
                                                                            size: size),
                                              headers: APIConstants.testTokenHeader,
                                              body: nil)

            NetworkLogger.log(request: request)

            return urlSession.rx.data(request: request)
                .map { try self.decode(data: $0,
                                       to: TotalFeed.self) }
                .asSingle()

        } catch {
            return Single.error(error)
        }
    }

}
