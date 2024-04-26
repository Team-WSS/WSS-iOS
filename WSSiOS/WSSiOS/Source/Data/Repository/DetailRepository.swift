//
//  DetailRepository.swift
//  WSSiOS
//
//  Created by 이윤학 on 4/25/24.
//

import Foundation

import RxSwift

protocol DummyDetailRepository {
    func getNovelBasic(novelId: Int) -> Observable<NovelDetailResult>
}

protocol DetailRepository {
    func getNovelBasic(novelId: Int) -> Observable<NovelDetailResult>
}

struct DefaultDetailRepository: DummyDetailRepository {
    func getNovelBasic(novelId: Int) -> Observable<NovelDetailResult> {
        return Observable.just(
            NovelDetailResult(userNovelID: 5,
                              novelTitle: "당신의 이해를 돕기 위하여",
                              novelImage: "url",
                              novelGenres: ["romanceFantasy", "romance"],
                              novelGenreURL: "url",
                              isNovelCompleted: true,
                              author: "이보라",
                              interestCount: 203,
                              novelRating: 4.4,
                              novelRatingCount: 153,
                              feedCount: 52,
                              userNovelRating: 5.0,
                              readStatus: "READING",
                              startDate: nil,
                              endDate: nil,
                              isUserNovelInterest: true)
        )
    }
}
