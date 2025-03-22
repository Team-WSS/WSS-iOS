//
//  SearchKeywordEntity.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 3/23/25.
//

import Foundation

struct SearchKeywordEntity {
    let categories: [KeywordCategory]
}

extension SearchKeywordResponse {
    func toEntity() -> SearchKeywordEntity {
        return SearchKeywordEntity(categories: self.categories)
    }
}
