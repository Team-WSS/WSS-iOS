//
//  KeywordRepository.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 9/10/24.
//

import Foundation

import RxSwift

protocol KeywordRepository {
    func getKeywords() -> Observable<DetailSearchCategories>
}

struct DefaultKeywordRepository: KeywordRepository {
    private let keywordService: KeywordService
    
    init(keywordService: KeywordService) {
        self.keywordService = keywordService
    }
    
    func getKeywords() -> Observable<DetailSearchCategories> {
        return keywordService.getSearchKeywords(query: "").asObservable()
    }
}

struct TestKeywordRepository: KeywordRepository {
    func getKeywords() -> Observable<DetailSearchCategories> {
        return Observable.just(DetailSearchCategories(categories: [
            DetailSearchCategory(categoryName: "세계관",
                                 categoryImage: "",
                                 keywords: [DetailSearchKeyword(keywordId: 1, keywordName: "이세계")])
        ]))
    }
}
