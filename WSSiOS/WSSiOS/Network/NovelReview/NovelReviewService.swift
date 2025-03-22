//
//  NovelReviewService.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 9/27/24.
//

import Foundation

import RxSwift

protocol NovelReviewService {
    func postNovelReview(novelReviewData: PostNovelReviewRequest) -> Single<Void>
    func putNovelReview(novelId: Int, novelReviewData: PutNovelReviewRequest) -> Single<Void>
    func getNovelReview(novelId: Int) -> Single<NovelReviewResponse>
}

final class DefaultNovelReviewService: NSObject, Networking, NovelReviewService {
    func postNovelReview(novelReviewData: PostNovelReviewRequest) -> Single<Void> {
        guard let novelReviewContentData = try? JSONEncoder().encode(novelReviewData) else {
            return Single.error(NetworkServiceError.invalidRequestError)
        }
        
        do {
            let request = try makeHTTPRequest(method: .post,
                                              path: URLs.NovelReview.postNovelReview,
                                              headers: APIConstants.accessTokenHeader,
                                              body: novelReviewContentData)
            
            NetworkLogger.log(request: request)
            
            return tokenCheckURLSession.rx.data(request: request)
                .map { _ in }
                .asSingle()
        } catch {
            return Single.error(error)
        }
    }
    
    func putNovelReview(novelId: Int, novelReviewData: PutNovelReviewRequest) -> Single<Void> {
        guard let novelReviewContentData = try? JSONEncoder().encode(novelReviewData) else {
            return Single.error(NetworkServiceError.invalidRequestError)
        }
        
        do {
            let request = try makeHTTPRequest(method: .put,
                                              path: URLs.NovelReview.putNovelReview(novelId: novelId),
                                              headers: APIConstants.accessTokenHeader,
                                              body: novelReviewContentData)
            
            NetworkLogger.log(request: request)
            
            return tokenCheckURLSession.rx.data(request: request)
                .map { _ in }
                .asSingle()
        } catch {
            return Single.error(error)
        }
    }
    
    func getNovelReview(novelId: Int) -> Single<NovelReviewResponse> {
        do {
            let request = try makeHTTPRequest(method: .get,
                                              path: URLs.NovelReview.getNovelReview(novelId: novelId),
                                              headers: APIConstants.accessTokenHeader,
                                              body: nil)
            
            NetworkLogger.log(request: request)
            
            return tokenCheckURLSession.rx.data(request: request)
                .map { try self.decode(data: $0,
                                       to: NovelReviewResponse.self) }
                .asSingle()
            
        } catch {
            return Single.error(error)
        }
    }
}
