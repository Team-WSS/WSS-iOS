//
//  NovelDetailService.swift
//  WSSiOS
//
//  Created by YunhakLee on 9/7/24.
//

import Foundation

import RxSwift

protocol NovelDetailService {
    func getNovelDetailHeaderData(novelId: Int) -> Single<NovelDetailHeaderResponse>
    func getNovelDetailInfoData(novelId: Int) -> Single<NovelDetailInfoResult>
    func getNovelDetailFeedData(novelId: Int, lastFeedId: Int, size: Int) -> Single<NovelDetailFeedResult>
    func postUserInterest(novelId: Int) -> Single<Void>
    func deleteUserInterest(novelId: Int) -> Single<Void>
    func deleteNovelReview(novelId: Int) -> Single<Void>
}

final class DefaultNovelDetailService: NSObject, Networking { }

extension DefaultNovelDetailService: NovelDetailService {
    func deleteNovelReview(novelId: Int) -> Single<Void> {
        do {
            let request = try makeHTTPRequest(method: .delete,
                                              path: URLs.NovelDetail.novelReview(novelId: novelId),
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
    
    func postUserInterest(novelId: Int) -> Single<Void> {
        do {
            let request = try makeHTTPRequest(method: .post,
                                              path: URLs.NovelDetail.novelIsInterest(novelId: novelId),
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
    
    func deleteUserInterest(novelId: Int) -> Single<Void> {
        do {
            let request = try makeHTTPRequest(method: .delete,
                                              path: URLs.NovelDetail.novelIsInterest(novelId: novelId),
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
    
    func getNovelDetailHeaderData(novelId: Int) -> Single<NovelDetailHeaderResponse> {
        do {
            let request = try makeHTTPRequest(method: .get,
                                              path: URLs.NovelDetail.novelDetailHeader(novelId: novelId),
                                              headers: APIConstants.accessTokenHeader,
                                              body: nil)
            
            NetworkLogger.log(request: request)
            
            return tokenCheckURLSession.rx.data(request: request)
                .map { try self.decode(data: $0,
                                       to: NovelDetailHeaderResponse.self) }
                .asSingle()
        } catch {
            return Single.error(error)
        }
    }
    
    func getNovelDetailInfoData(novelId: Int) -> Single<NovelDetailInfoResult> {
        do {
            let request = try makeHTTPRequest(method: .get,
                                              path: URLs.NovelDetail.novelDetailInfo(novelId: novelId),
                                              headers: APIConstants.accessTokenHeader,
                                              body: nil)
            
            NetworkLogger.log(request: request)
            
            return tokenCheckURLSession.rx.data(request: request)
                .map { try self.decode(data: $0,
                                       to: NovelDetailInfoResult.self) }
                .asSingle()
        } catch {
            return Single.error(error)
        }
    }
    
    func getNovelDetailFeedData(novelId: Int, lastFeedId: Int, size: Int) -> Single<NovelDetailFeedResult> {
        let novelDetailFeedQueryItems: [URLQueryItem] = [
            URLQueryItem(name: "lastFeedId", value: String(describing: lastFeedId)),
            URLQueryItem(name: "size", value: String(describing: size))
        ]
        do {
            let request = try makeHTTPRequest(method: .get,
                                              path: URLs.NovelDetail.novelDetailFeed(novelId: novelId),
                                              queryItems: novelDetailFeedQueryItems,
                                              headers: APIConstants.accessTokenHeader,
                                              body: nil)
            
            NetworkLogger.log(request: request)
            
            return tokenCheckURLSession.rx.data(request: request)
                .map { try self.decode(data: $0,
                                       to: NovelDetailFeedResult.self) }
                .asSingle()
        } catch {
            return Single.error(error)
        }
    }
}
