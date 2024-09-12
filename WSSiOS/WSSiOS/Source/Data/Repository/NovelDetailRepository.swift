//
//  DetailRepository.swift
//  WSSiOS
//
//  Created by 이윤학 on 4/25/24.
//

import Foundation

import RxSwift

protocol NovelDetailRepository {
    func getNovelDetailHeaderData(novelId: Int) -> Observable<NovelDetailHeaderResult>
    func getNovelDetailInfoData(novelId: Int) -> Observable<NovelDetailInfoResult>
    func postUserInterest(novelId: Int) -> Observable<Void>
    func deleteUserInterest(novelId: Int) -> Observable<Void>
}

struct TestDetailRepository: NovelDetailRepository {
    func postUserInterest(novelId: Int) -> Observable<Void> {
        return Observable.just(())
    }
    
    func deleteUserInterest(novelId: Int) -> Observable<Void> {
        return Observable.just(())
    }
    
    func getNovelDetailHeaderData(novelId: Int) -> Observable<NovelDetailHeaderResult> {
        return Observable.just(NovelDetailHeaderResult.dummyFullData[0])
    }
    
    func getNovelDetailInfoData(novelId: Int) -> Observable<NovelDetailInfoResult> {
        return Observable.just(NovelDetailInfoResult.dummyFullData[0])
    }
}

struct DefaultDetailRepository: NovelDetailRepository {
    func postUserInterest(novelId: Int) -> Observable<Void> {
        return novelDetailService.postUserInterest(novelId: novelId).asObservable()
    }
    
    func deleteUserInterest(novelId: Int) -> Observable<Void> {
        return novelDetailService.deleteUserInterest(novelId: novelId).asObservable()
    }
    
    private let novelDetailService: NovelDetailService

    init(novelDetailService: NovelDetailService) {
        self.novelDetailService = novelDetailService
    }

    func getNovelDetailHeaderData(novelId: Int) -> Observable<NovelDetailHeaderResult> {
        return novelDetailService.getNovelDetailHeaderData(novelId: novelId).asObservable()
    }
    
    func getNovelDetailInfoData(novelId: Int) -> Observable<NovelDetailInfoResult> {
        return novelDetailService.getNovelDetailInfoData(novelId: novelId).asObservable()
    }
}

