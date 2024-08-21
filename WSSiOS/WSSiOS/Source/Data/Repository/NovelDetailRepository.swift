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
}

struct TestDetailRepository: NovelDetailRepository {
    func getNovelDetailHeaderData(novelId: Int) -> Observable<NovelDetailHeaderResult> {
        return Observable.just(NovelDetailHeaderResult.dummyData[2])
    }
    
    func getNovelDetailInfoData(novelId: Int) -> Observable<NovelDetailInfoResult> {
        return Observable.just(NovelDetailInfoResult.dummyFullData[0])
    }
}
