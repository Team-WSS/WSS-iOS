//
//  FeedService.swift
//  WSSiOS
//
//  Created by 신지원 on 6/3/24.
//

import UIKit

import RxSwift

protocol FeedService {
    func getFeedList(lastFeedId: Int, size: Int, feedsOption: String) -> Single<TotalFeedListResponse>
    func postFeed(relevantCategories: [String], feedContent: String, novelId: Int?, isSpoiler: Bool, isPublic: Bool, images: [UIImage]) -> Single<Void>
    func putFeed(feedId: Int, relevantCategories: [String], feedContent: String, novelId: Int?, isSpoiler: Bool, isPublic: Bool, images: [UIImage]) -> Single<Void>
}

final class DefaultFeedService: NSObject, Networking, FeedService {
    func makeFeedListQuery(lastFeedId: Int,
                           size: Int,
                           feedsOption: String) -> [URLQueryItem] {
        return [
            URLQueryItem(name: "lastFeedId", value: String(describing: lastFeedId)),
            URLQueryItem(name: "size", value: String(describing: size)),
            URLQueryItem(name: "feedsOption", value: String(describing: feedsOption)),
        ]
    }
    
    func getFeedList(lastFeedId: Int, size: Int, feedsOption: String) -> Single<TotalFeedListResponse> {
        do {
            let request = try makeHTTPRequest(method: .get,
                                              path: URLs.Feed.getFeeds,
                                              queryItems: makeFeedListQuery(lastFeedId: lastFeedId,
                                                                            size: size,
                                                                            feedsOption: feedsOption),
                                              headers: APIConstants.accessTokenHeader,
                                              body: nil)
            
            NetworkLogger.log(request: request)
            return tokenCheckURLSession.rx.data(request: request)
                .map { try self.decode(data: $0,
                                       to: TotalFeedListResponse.self) }
                .asSingle()
            
        } catch {
            return Single.error(error)
        }
    }
    
    func postFeed(relevantCategories: [String], feedContent: String, novelId: Int?, isSpoiler: Bool, isPublic: Bool, images: [UIImage]) -> Single<Void> {
        let feed = FeedContentRequest(relevantCategories: relevantCategories,
                                      feedContent: feedContent,
                                      novelId: novelId,
                                      isSpoiler: isSpoiler,
                                      isPublic: isPublic)
        
        guard let jsonData = try? JSONEncoder().encode(feed) else {
            return Single.error(NetworkServiceError.invalidRequestError)
        }
        
        let compressedImages = compressImages(images)
        
        let boundary = MultipartConstants.makeBoundary()
        
        let body = makeMultipartBodyWithJSONAndImages(
            jsonPartName: MultipartConstants.jsonPartName,
            jsonData: jsonData,
            imageKeyName: MultipartConstants.imageKeyName,
            images: compressedImages,
            boundary: boundary
        )
        
        let headers: [String: String] = MultipartConstants.headers(boundary: boundary)
        
        do {
            let request = try makeHTTPRequest(method: .post,
                                              path: URLs.Feed.postFeed,
                                              headers: headers,
                                              body: body)
            
            NetworkLogger.log(request: request)
            
            return tokenCheckURLSession.rx.data(request: request)
                .map { _ in }
                .asSingle()
        } catch {
            return Single.error(error)
        }
    }
    
    func putFeed(feedId: Int, relevantCategories: [String], feedContent: String, novelId: Int?, isSpoiler: Bool, isPublic: Bool, images: [UIImage]) -> Single<Void> {
        
        let feed = FeedContentRequest(relevantCategories: relevantCategories,
                                      feedContent: feedContent,
                                      novelId: novelId,
                                      isSpoiler: isSpoiler,
                                      isPublic: isPublic)
        
        guard let jsonData = try? JSONEncoder().encode(feed) else {
            return Single.error(NetworkServiceError.invalidRequestError)
        }
        
        let compressedImages = compressImages(images)
        
        let boundary = MultipartConstants.makeBoundary()
        
        let body = makeMultipartBodyWithJSONAndImages(
            jsonPartName: MultipartConstants.jsonPartName,
            jsonData: jsonData,
            imageKeyName: MultipartConstants.imageKeyName,
            images: compressedImages,
            boundary: boundary
        )
        
        let headers: [String: String] = MultipartConstants.headers(boundary: boundary)
        
        do {
            let request = try makeHTTPRequest(method: .put,
                                              path: URLs.Feed.putFeed(feedId: feedId),
                                              headers: headers,
                                              body: body)
            
            NetworkLogger.log(request: request)
            
            return tokenCheckURLSession.rx.data(request: request)
                .map { _ in }
                .asSingle()
        } catch {
            return Single.error(error)
        }
    }
}
