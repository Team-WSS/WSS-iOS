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
                               isCompleted: Bool?,
                               lowerNovelRating: Float,
                               upperNovelRating: Float,
                               keywordIds: [Int],
                               page: Int) -> Observable<DetailSearchNovels>
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
                               isCompleted: Bool?,
                               lowerNovelRating: Float,
                               upperNovelRating: Float,
                               keywordIds: [Int],
                               page: Int) -> Observable<DetailSearchNovels> {
        return searchService.searchDetailNovels(genres: genres,
                                                isCompleted: isCompleted,
                                                lowerNovelRating: lowerNovelRating,
                                                upperNovelRating: upperNovelRating,
                                                keywordIds: keywordIds,
                                                page: page,
                                                size: searchSize).asObservable()
    }
}
