//
//  NovelReviewService.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 9/27/24.
//

import Foundation

import RxSwift

protocol NovelReviewService {
    func postNovelReview(novelId: Int,
                         userNovelRating: Float,
                         status: String,
                         startDate: String?,
                         endDate: String?,
                         attractivePoints: [String],
                         keywordIds: [Int]) -> Single<Void>
    func putNovelReview(novelId: Int,
                        userNovelRating: Float,
                        status: String,
                        startDate: String?,
                        endDate: String?,
                        attractivePoints: [String],
                        keywordIds: [Int]) -> Single<Void>
    func getNovelReview(novelId: Int) -> Single<NovelReviewResult>
}

final class DefaultNovelReviewService: NSObject, Networking, NovelReviewService {
    func postNovelReview(novelId: Int,
                         userNovelRating: Float,
                         status: String,
                         startDate: String?,
                         endDate: String?,
                         attractivePoints: [String],
                         keywordIds: [Int]) -> Single<Void> {
        guard let novelReviewContentData = try? JSONEncoder().encode(PostNovelReviewContent(novelId: novelId, userNovelRating: userNovelRating, status: status, startDate: startDate, endDate: endDate, attractivePoints: attractivePoints, keywordIds: keywordIds)) else {
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
    
    func putNovelReview(novelId: Int,
                         userNovelRating: Float,
                         status: String,
                         startDate: String?,
                         endDate: String?,
                         attractivePoints: [String],
                         keywordIds: [Int]) -> Single<Void> {
        guard let novelReviewContentData = try? JSONEncoder().encode(PutNovelReviewContent(userNovelRating: userNovelRating, status: status, startDate: startDate, endDate: endDate, attractivePoints: attractivePoints, keywordIds: keywordIds)) else {
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
    
    func getNovelReview(novelId: Int) -> Single<NovelReviewResult> {
        do {
            let request = try makeHTTPRequest(method: .get,
                                              path: URLs.NovelReview.getNovelReview(novelId: novelId),
                                              headers: APIConstants.accessTokenHeader,
                                              body: nil)
            
            NetworkLogger.log(request: request)
            
            return tokenCheckURLSession.rx.data(request: request)
                .map { try self.decode(data: $0,
                                       to: NovelReviewResult.self) }
                .asSingle()
            
        } catch {
            return Single.error(error)
        }
    }
}
