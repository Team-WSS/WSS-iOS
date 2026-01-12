//
//  NovelReviewRepository.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 9/27/24.
//

import Foundation

import RxSwift

protocol NovelReviewRepository {
    func postNovelReview(novelId: Int,
                         userNovelRating: Float,
                         status: String,
                         startDate: String?,
                         endDate: String?,
                         attractivePoints: [String],
                         keywordIds: [Int]) -> Observable<Void>
    func putNovelReview(novelId: Int,
                        userNovelRating: Float,
                        status: String,
                        startDate: String?,
                        endDate: String?,
                        attractivePoints: [String],
                        keywordIds: [Int]) -> Observable<Void>
    func getNovelReview(novelId: Int) -> Observable<NovelReviewResult>
}

struct DefaultNovelReviewRepository: NovelReviewRepository {
    private var novelReviewService: NovelReviewService
    
    init(novelReviewService: NovelReviewService) {
        self.novelReviewService = novelReviewService
    }
    
    func postNovelReview(novelId: Int,
                         userNovelRating: Float,
                         status: String,
                         startDate: String?,
                         endDate: String?,
                         attractivePoints: [String],
                         keywordIds: [Int]) -> Observable<Void> {
        return novelReviewService.postNovelReview(novelId: novelId,
                                                  userNovelRating: userNovelRating,
                                                  status: status,
                                                  startDate: startDate,
                                                  endDate: endDate,
                                                  attractivePoints: attractivePoints,
                                                  keywordIds: keywordIds)
        .asObservable()
    }
    
    func putNovelReview(novelId: Int,
                        userNovelRating: Float,
                        status: String,
                        startDate: String?,
                        endDate: String?,
                        attractivePoints: [String],
                        keywordIds: [Int]) -> Observable<Void> {
        return novelReviewService.putNovelReview(novelId: novelId,
                                                 userNovelRating: userNovelRating,
                                                 status: status,
                                                 startDate: startDate,
                                                 endDate: endDate,
                                                 attractivePoints: attractivePoints,
                                                 keywordIds: keywordIds)
        .asObservable()
    }
    
    func getNovelReview(novelId: Int) -> Observable<NovelReviewResult> {
        return novelReviewService.getNovelReview(novelId: novelId)
            .asObservable()
    }
}
