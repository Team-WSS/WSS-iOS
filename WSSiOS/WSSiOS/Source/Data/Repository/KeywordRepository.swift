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
}

struct DefaultKeywordRepository: KeywordRepository {
    
    private var keywordService: KeywordService
    
    init(keywordService: KeywordService) {
        self.keywordService = keywordService
    }
    
    func searchKeyword(query: String?) -> Observable<SearchKeywordResult> {
        return keywordService.searchKeyword(query: query)
            .asObservable()
    }
}
