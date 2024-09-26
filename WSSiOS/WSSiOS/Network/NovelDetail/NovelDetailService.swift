//
//  NovelDetailService.swift
//  WSSiOS
//
//  Created by YunhakLee on 9/7/24.
//

import Foundation

import RxSwift

protocol NovelDetailService {
    func getNovelDetailHeaderData(novelId: Int) -> Single<NovelDetailHeaderResult>
    func getNovelDetailInfoData(novelId: Int) -> Single<NovelDetailInfoResult>
    func postUserInterest(novelId: Int) -> Single<Void>
    func deleteUserInterest(novelId: Int) -> Single<Void>
    func deleteNovelReview(novelId: Int) -> Single<Void>
}

final class DefaultNovelDetailService: NSObject, Networking {
    private var urlSession: URLSession = URLSession(configuration: URLSessionConfiguration.default,
                                                    delegate: nil,
                                                    delegateQueue: nil)
}

extension DefaultNovelDetailService: NovelDetailService {
    func deleteNovelReview(novelId: Int) -> Single<Void> {
        do {
            let request = try makeHTTPRequest(method: .delete,
                                              path: URLs.NovelDetail.novelReview(novelId: novelId),
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
    
    func postUserInterest(novelId: Int) -> Single<Void> {
        do {
            let request = try makeHTTPRequest(method: .post,
                                              path: URLs.NovelDetail.novelIsInterest(novelId: novelId),
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
    
    func deleteUserInterest(novelId: Int) -> Single<Void> {
        do {
            let request = try makeHTTPRequest(method: .delete,
                                              path: URLs.NovelDetail.novelIsInterest(novelId: novelId),
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
    
    func getNovelDetailHeaderData(novelId: Int) -> Single<NovelDetailHeaderResult> {
        do {
            let request = try makeHTTPRequest(method: .get,
                                              path: URLs.NovelDetail.novelDetailHeader(novelId: novelId),
                                              headers: APIConstants.testTokenHeader,
                                              body: nil)
            
            NetworkLogger.log(request: request)
            
            return urlSession.rx.data(request: request)
                .map { try self.decode(data: $0,
                                       to: NovelDetailHeaderResult.self) }
                .asSingle()
        } catch {
            return Single.error(error)
        }
    }
    
    func getNovelDetailInfoData(novelId: Int) -> Single<NovelDetailInfoResult> {
        do {
            let request = try makeHTTPRequest(method: .get,
                                              path: URLs.NovelDetail.novelDetailInfo(novelId: novelId),
                                              headers: APIConstants.testTokenHeader,
                                              body: nil)
            
            NetworkLogger.log(request: request)
            
            return urlSession.rx.data(request: request)
                .map { try self.decode(data: $0,
                                       to: NovelDetailInfoResult.self) }
                .asSingle()
        } catch {
            return Single.error(error)
        }
    }
}
