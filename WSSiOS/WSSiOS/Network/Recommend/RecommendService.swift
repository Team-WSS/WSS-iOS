//
//  RecommendService.swift
//  WSSiOS
//
//  Created by 최서연 on 1/14/24.
//

import Foundation

import RxSwift

protocol RecommendService {
    func getTodayPopularNovels() -> Single<TodayPopularNovels>
    func getRealtimePopularFeeds() -> Single<[RealtimePopularFeed]>
    func getInterestFeeds() -> Single<[InterestFeed]>
    func getTasteRecommendNovels() -> Single<[TasteRecommendNovel]>
}

final class DefaultRecommendService: NSObject, Networking {
    
    private var urlSession = URLSession(configuration: URLSessionConfiguration.default,
                                        delegate: nil,
                                        delegateQueue: nil)
}

extension DefaultRecommendService: RecommendService {
    /// 오늘의 인기작 조회
    func getTodayPopularNovels() -> Single<TodayPopularNovels> {
        do {
            let request = try makeHTTPRequest(method: .get,
                                              path: URLs.Recommend.getTodayPopulars,
                                              headers: APIConstants.testTokenHeader,
                                              body: nil)
            
            NetworkLogger.log(request: request)
            
            return urlSession.rx.data(request: request)
                .map { try self.decode(data: $0,
                                       to: TodayPopularNovels.self) }
                .asSingle()
            
        } catch {
            return Single.error(error)
        }
    }
    
    /// 지금 뜨는 수다글 조회
    func getRealtimePopularFeeds() -> Single<[RealtimePopularFeed]> {
        do {
            let request = try makeHTTPRequest(method: .get,
                                              path: URLs.Recommend.getRealtimePopulars,
                                              headers: APIConstants.testTokenHeader,
                                              body: nil)
            
            NetworkLogger.log(request: request)
            
            return urlSession.rx.data(request: request)
                .map { try self.decode(data: $0,
                                       to: [RealtimePopularFeed].self) }
                .asSingle()
            
        } catch {
            return Single.error(error)
        }
    }
    
    /// 관심글 조회
    func getInterestFeeds() -> Single<[InterestFeed]> {
        do {
            let request = try makeHTTPRequest(method: .get,
                                              path: URLs.Recommend.getInterestFeeds,
                                              headers: APIConstants.testTokenHeader,
                                              body: nil)
            
            NetworkLogger.log(request: request)
            
            return urlSession.rx.data(request: request)
                .map { try self.decode(data: $0,
                                       to: [InterestFeed].self) }
                .asSingle()
            
        } catch {
            return Single.error(error)
        }
    }
    
    /// 취향 추천 작품 조회
    func getTasteRecommendNovels() -> Single<[TasteRecommendNovel]> {
        do {
            let request = try makeHTTPRequest(method: .get,
                                              path: URLs.Recommend.getTasteRecommendNovels,
                                              headers: APIConstants.testTokenHeader,
                                              body: nil)
            
            NetworkLogger.log(request: request)
            
            return urlSession.rx.data(request: request)
                .map { try self.decode(data: $0,
                                       to: [TasteRecommendNovel].self) }
                .asSingle()
            
        } catch {
            return Single.error(error)
        }
    }
}
