//
//  SearchRepository.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/27/24.
//

import Foundation

import RxSwift

protocol SearchRepository {
    func getSosoPickNovels() -> Observable<SosoPickNovels>
    func getSearchNovels(query: String) -> Observable<NormalSearchNovels>
}

struct DefaultSearchRepository: SearchRepository {
    private var searchService: SearchService
    
    init(searchService: SearchService) {
        self.searchService = searchService
    }
    
    func getSosoPickNovels() -> Observable<SosoPickNovels> {
        return searchService.getSosopicks().asObservable()
    }
    
    func getSearchNovels(query: String) -> Observable<NormalSearchNovels> {
        return searchService.searchNormalNovels(query: query, page: 0, size: 30).asObservable()
    }
}

struct TestSearchRepository: SearchRepository {
    func getSosoPickNovels() -> Observable<SosoPickNovels> {
        return Observable.just(SosoPickNovels(sosoPicks: [
            SosoPickNovel(novelId: 1, novelImage: "imgTest2", novelTitle: "구리구리스"),
            SosoPickNovel(novelId: 1, novelImage: "imgTest2", novelTitle: "구리구리뱅"),
            SosoPickNovel(novelId: 1, novelImage: "imgTest2", novelTitle: "상수리 나무 아래"),
            SosoPickNovel(novelId: 1, novelImage: "imgTest2", novelTitle: "하수리 나무 위"),
            SosoPickNovel(novelId: 1, novelImage: "imgTest2", novelTitle: "하수리수리마수리"),
            SosoPickNovel(novelId: 1, novelImage: "imgTest2", novelTitle: "딱대"),
            SosoPickNovel(novelId: 1, novelImage: "imgTest2", novelTitle: "토크쇼"),
            SosoPickNovel(novelId: 1, novelImage: "imgTest2", novelTitle: "배고파"),
            SosoPickNovel(novelId: 1, novelImage: "imgTest2", novelTitle: "닭가슴살꼬치먹고싶다힝구힝구힝")]))
    }
    
    func getSearchNovels(query: String) -> Observable<NormalSearchNovels> {
        return Observable.just(NormalSearchNovels(resultCount: 1003, isLoadable: true, novels: [
            NormalSearchNovel(novelId: 2, novelImage: "https://i.pinimg.com/564x/f7/8f/e1/f78fe156e361a321b5d1334e5f21f031.jpg", novelTitle: "구리구리구리구리구리구리구리구리구리구리구리구리구리구리구리구리구구리구리구리구리구리구리구리구리구리구리구리구리구리구리구리구리구리구리리구리", novelAuthor: "구리스구리스최서연최서연구리구리구리구리구리구리구리구리구리구리구리구리", interestCount: 13, novelRating: 2.34, novelRatingCount: 221),
            NormalSearchNovel(novelId: 2, novelImage: "https://i.pinimg.com/564x/70/54/70/705470563de4ad028c5323fe2ac16628.jpg", novelTitle: "구리구리구리구리구리구리", novelAuthor: "구리스구리스최서연최서연", interestCount: 123, novelRating: 2.34, novelRatingCount: 21),
            NormalSearchNovel(novelId: 2, novelImage: "https://i.pinimg.com/564x/4a/63/a3/4a63a3eda53a5d685c8593869947d06c.jpg", novelTitle: "구리구리구리구리구리구리", novelAuthor: "구리스구리스최서연최서연", interestCount: 123, novelRating: 2.34, novelRatingCount: 21),
            NormalSearchNovel(novelId: 2, novelImage: "https://i.pinimg.com/564x/70/54/70/705470563de4ad028c5323fe2ac16628.jpg", novelTitle: "구리구리구리구리구리구리", novelAuthor: "구리스구리스최서연최서연", interestCount: 123, novelRating: 2.34, novelRatingCount: 21),
            NormalSearchNovel(novelId: 2, novelImage: "https://i.pinimg.com/564x/4a/63/a3/4a63a3eda53a5d685c8593869947d06c.jpg", novelTitle: "구리구리구리구리구리구리", novelAuthor: "구리스구리스최서연최서연", interestCount: 123, novelRating: 2.34, novelRatingCount: 21),
            NormalSearchNovel(novelId: 2, novelImage: "https://i.pinimg.com/564x/70/54/70/705470563de4ad028c5323fe2ac16628.jpg", novelTitle: "구리구리구리구리구리구리", novelAuthor: "구리스구리스최서연최서연", interestCount: 123, novelRating: 2.34, novelRatingCount: 21),NormalSearchNovel(novelId: 2, novelImage: "https://i.pinimg.com/564x/f7/8f/e1/f78fe156e361a321b5d1334e5f21f031.jpg", novelTitle: "구리구리구리구리구리구리", novelAuthor: "구리스구리스최서연최서연", interestCount: 123, novelRating: 2.34, novelRatingCount: 21),
            NormalSearchNovel(novelId: 2, novelImage: "https://i.pinimg.com/564x/4a/63/a3/4a63a3eda53a5d685c8593869947d06c.jpg", novelTitle: "구리구리구리구리구리구리", novelAuthor: "구리스구리스최서연최서연", interestCount: 123, novelRating: 2.34, novelRatingCount: 21),
            NormalSearchNovel(novelId: 2, novelImage: "https://i.pinimg.com/564x/4a/63/a3/4a63a3eda53a5d685c8593869947d06c.jpg", novelTitle: "구리구리구리구리구리구리", novelAuthor: "구리스구리스최서연최서연", interestCount: 123, novelRating: 2.34, novelRatingCount: 21),
            NormalSearchNovel(novelId: 2, novelImage: "https://i.pinimg.com/564x/f7/8f/e1/f78fe156e361a321b5d1334e5f21f031.jpg", novelTitle: "구리구리구리구리구리구리", novelAuthor: "구리스구리스최서연최서연", interestCount: 123, novelRating: 2.34, novelRatingCount: 21),
            NormalSearchNovel(novelId: 2, novelImage: "https://i.pinimg.com/564x/f7/8f/e1/f78fe156e361a321b5d1334e5f21f031.jpg", novelTitle: "구리구리구리구리구리구리", novelAuthor: "구리스구리스최서연최서연", interestCount: 123, novelRating: 2.34, novelRatingCount: 21),
            NormalSearchNovel(novelId: 2, novelImage: "https://i.pinimg.com/564x/f7/8f/e1/f78fe156e361a321b5d1334e5f21f031.jpg", novelTitle: "구리구리구리구리구리구리", novelAuthor: "구리스구리스최서연최서연", interestCount: 123, novelRating: 2.34, novelRatingCount: 21)]))
    }
}
