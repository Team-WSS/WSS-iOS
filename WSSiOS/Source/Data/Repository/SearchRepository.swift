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
    func getSearchNovels(query: String, page: Int) -> Observable<NormalSearchNovels>
    func getDetailSearchNovels(genres: [String],
                               platforms: [String],
                               isCompleted: Bool?,
                               lowerNovelRating: Float,
                               upperNovelRating: Float,
                               keywordIds: [Int],
                               page: Int) -> Observable<DetailSearchNovels>
    func getRecentSearches() -> Observable<[RecentSearch]>
    func deleteRecentSearch(id: Int) -> Observable<Void>
    func deleteAllRecentSearches() -> Observable<Void>
}

struct DefaultSearchRepository: SearchRepository {
    private var searchService: SearchService
    private let searchSize = 20
    
    init(searchService: SearchService) {
        self.searchService = searchService
    }
    
    func getSosoPickNovels() -> Observable<SosoPickNovels> {
        return searchService.getSosopicks().asObservable()
    }
    
    func getSearchNovels(query: String, page: Int) -> Observable<NormalSearchNovels> {
        return searchService.searchNormalNovels(query: query,
                                                page: page,
                                                size: searchSize).asObservable()
    }
    
    func getDetailSearchNovels(genres: [String],
                               platforms: [String],
                               isCompleted: Bool?,
                               lowerNovelRating: Float,
                               upperNovelRating: Float,
                               keywordIds: [Int],
                               page: Int) -> Observable<DetailSearchNovels> {
        return searchService.searchDetailNovels(genres: genres,
                                                platforms: platforms,
                                                isCompleted: isCompleted,
                                                lowerNovelRating: lowerNovelRating,
                                                upperNovelRating: upperNovelRating,
                                                keywordIds: keywordIds,
                                                page: page,
                                                size: searchSize).asObservable()
    }

    func getRecentSearches() -> Observable<[RecentSearch]> {
        return searchService.getRecentSearches().asObservable()
    }

    func deleteRecentSearch(id: Int) -> Observable<Void> {
        return searchService.deleteRecentSearch(id: id).asObservable()
    }

    func deleteAllRecentSearches() -> Observable<Void> {
        return searchService.deleteAllRecentSearches().asObservable()
    }
}
