//
//  DetailRepository.swift
//  WSSiOS
//
//  Created by 이윤학 on 4/25/24.
//

import Foundation

import RxSwift

protocol NovelDetailRepository {
    func getNovelBasic(novelId: Int) -> Observable<NovelDetailHeaderResult>
}

struct TestDetailRepository: NovelDetailRepository {
    func getNovelBasic(novelId: Int) -> Observable<NovelDetailHeaderResult> {
        return Observable.just(NovelDetailHeaderResult.dummyData[0])
    }
}
