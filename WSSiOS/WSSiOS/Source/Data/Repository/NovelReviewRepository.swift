//
//  NovelReviewRepository.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 9/27/24.
//

import Foundation

import RxSwift

protocol NovelReviewRepository {
    func postNovelReview(novelReviewData: PostNovelReviewEntity) -> Observable<Void>
    func putNovelReview(novelId: Int, novelReviewData: PutNovelReviewEntity) -> Observable<Void>
    func getNovelReview(novelId: Int) -> Observable<NovelReviewEntity>
}

struct DefaultNovelReviewRepository: NovelReviewRepository {
    private var novelReviewService: NovelReviewService
    
    init(novelReviewService: NovelReviewService) {
        self.novelReviewService = novelReviewService
    }
    
    func postNovelReview(novelReviewData: PostNovelReviewEntity) -> Observable<Void> {
        let novelReviewDataDTO = novelReviewData.toDTO()
        return novelReviewService.postNovelReview(novelReviewData: novelReviewDataDTO)
            .asObservable()
    }
    
    func putNovelReview(novelId: Int, novelReviewData: PutNovelReviewEntity) -> Observable<Void> {
        let novelReviewDataDTO = novelReviewData.toDTO()
        return novelReviewService.putNovelReview(novelId: novelId, novelReviewData: novelReviewDataDTO)
            .asObservable()
    }
    
    func getNovelReview(novelId: Int) -> Observable<NovelReviewEntity> {
        return novelReviewService.getNovelReview(novelId: novelId)
            .map { $0.toEntity() }
            .asObservable()
    }
}
