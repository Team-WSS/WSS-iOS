//
//  SearchRepository.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/27/24.
//

import Foundation

import RxSwift

protocol SearchRepository {
    func getSosoPickNovels() -> Observable<[SosoPickNovel]>
    func getSearchNovels() -> Observable<[NormalSearchNovel]>
}

struct TestSearchRepository: SearchRepository {
    func getSosoPickNovels() -> Observable<[SosoPickNovel]> {
        return Observable.just([SosoPickNovel(novelId: 1, novelImage: "imgTest2", novelTitle: "구리구리스"),
                                SosoPickNovel(novelId: 1, novelImage: "imgTest2", novelTitle: "구리구리뱅"),
                                SosoPickNovel(novelId: 1, novelImage: "imgTest2", novelTitle: "상수리 나무 아래"),
                                SosoPickNovel(novelId: 1, novelImage: "imgTest2", novelTitle: "하수리 나무 위"),
                                SosoPickNovel(novelId: 1, novelImage: "imgTest2", novelTitle: "하수리수리마수리"),
                                SosoPickNovel(novelId: 1, novelImage: "imgTest2", novelTitle: "딱대"),
                                SosoPickNovel(novelId: 1, novelImage: "imgTest2", novelTitle: "토크쇼"),
                                SosoPickNovel(novelId: 1, novelImage: "imgTest2", novelTitle: "배고파"),
                                SosoPickNovel(novelId: 1, novelImage: "imgTest2", novelTitle: "닭가슴살꼬치먹고싶다힝구힝구힝")])
    }
    
    func getSearchNovels() -> Observable<[NormalSearchNovel]> {
        return Observable.just([NormalSearchNovel(novelId: 2, novelImage: "imgTest2", novelTitle: "구리구리구리구리구리구리구리구리구리구리구리구리구리구리구리구리구리구리", novelAuthor: "구리스구리스최서연최서연구리구리구리구리구리구리구리구리구리구리구리구리", interestCount: 13, ratingAverage: 2.34, ratingCount: 221),
                                NormalSearchNovel(novelId: 2, novelImage: "imgTest2", novelTitle: "구리구리구리구리구리구리", novelAuthor: "구리스구리스최서연최서연", interestCount: 123, ratingAverage: 2.34, ratingCount: 21),
                                NormalSearchNovel(novelId: 2, novelImage: "imgTest2", novelTitle: "구리구리구리구리구리구리", novelAuthor: "구리스구리스최서연최서연", interestCount: 123, ratingAverage: 2.34, ratingCount: 21),
                                NormalSearchNovel(novelId: 2, novelImage: "imgTest2", novelTitle: "구리구리구리구리구리구리", novelAuthor: "구리스구리스최서연최서연", interestCount: 123, ratingAverage: 2.34, ratingCount: 21),
                                NormalSearchNovel(novelId: 2, novelImage: "imgTest2", novelTitle: "구리구리구리구리구리구리", novelAuthor: "구리스구리스최서연최서연", interestCount: 123, ratingAverage: 2.34, ratingCount: 21),
                                NormalSearchNovel(novelId: 2, novelImage: "imgTest2", novelTitle: "구리구리구리구리구리구리", novelAuthor: "구리스구리스최서연최서연", interestCount: 123, ratingAverage: 2.34, ratingCount: 21),NormalSearchNovel(novelId: 2, novelImage: "imgTest2", novelTitle: "구리구리구리구리구리구리", novelAuthor: "구리스구리스최서연최서연", interestCount: 123, ratingAverage: 2.34, ratingCount: 21),
                                NormalSearchNovel(novelId: 2, novelImage: "imgTest2", novelTitle: "구리구리구리구리구리구리", novelAuthor: "구리스구리스최서연최서연", interestCount: 123, ratingAverage: 2.34, ratingCount: 21),
                                NormalSearchNovel(novelId: 2, novelImage: "imgTest2", novelTitle: "구리구리구리구리구리구리", novelAuthor: "구리스구리스최서연최서연", interestCount: 123, ratingAverage: 2.34, ratingCount: 21),NormalSearchNovel(novelId: 2, novelImage: "imgTest2", novelTitle: "구리구리구리구리구리구리", novelAuthor: "구리스구리스최서연최서연", interestCount: 123, ratingAverage: 2.34, ratingCount: 21),
                                NormalSearchNovel(novelId: 2, novelImage: "imgTest2", novelTitle: "구리구리구리구리구리구리", novelAuthor: "구리스구리스최서연최서연", interestCount: 123, ratingAverage: 2.34, ratingCount: 21),
                                NormalSearchNovel(novelId: 2, novelImage: "imgTest2", novelTitle: "구리구리구리구리구리구리", novelAuthor: "구리스구리스최서연최서연", interestCount: 123, ratingAverage: 2.34, ratingCount: 21)])
    }
}
