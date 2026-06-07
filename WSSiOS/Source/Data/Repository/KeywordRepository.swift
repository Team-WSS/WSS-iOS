//
//  KeywordRepository.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 9/27/24.
//

import Foundation

import RxSwift

protocol KeywordRepository {
    func searchKeyword(query: String?) -> Observable<SearchKeywordResult>
    func getPopularKeywords() -> Observable<[KeywordData]>
}

struct DefaultKeywordRepository: KeywordRepository {

    private var keywordService: KeywordService
    private let popularKeywordSize = 7

    init(keywordService: KeywordService) {
        self.keywordService = keywordService
    }

    func searchKeyword(query: String?) -> Observable<SearchKeywordResult> {
        return keywordService.searchKeyword(query: query)
            .asObservable()
    }

    func getPopularKeywords() -> Observable<[KeywordData]> {
        return keywordService.getPopularKeywords(size: popularKeywordSize)
            .asObservable()
    }
}
