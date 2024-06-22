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
        return Observable.just(
            NovelDetailHeaderResult(userNovelID: nil,
                              novelTitle: "여자친구로 삼으려고 학생회장을 꼭 닮은 여자아이를 연성했다가 내가 하인이 됐습니다",
                              novelImage: "ImgNovelCoverDummy",
                              novelGenres: ["romanceFantasy", "romance"],
                              novelGenreImage: "icGenreLabelRfDummy",
                              isNovelCompleted: false,
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
//            DetailBasicResult(userNovelID: 5,
//                              novelTitle: "당신의 이해를 돕기 위하여",
//                              novelImage: "ImgNovelCoverDummy",
//                              novelGenres: ["romanceFantasy", "romance"],
//                              novelGenreURL: "icGenreLabelRfDummy",
//                              isNovelCompleted: true,
//                              author: "이보라",
//                              interestCount: 203,
//                              novelRating: 4.4,
//                              novelRatingCount: 153,
//                              feedCount: 52,
//                              userNovelRating: 5.0,
//                              readStatus: "FINISHED",
//                              startDate: "23년 12월 25일",
//                              endDate: "24년 1월 5일",
//                              isUserNovelInterest: true)
        )
    }
}
