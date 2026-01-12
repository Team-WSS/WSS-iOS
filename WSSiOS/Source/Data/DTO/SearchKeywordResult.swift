//
//  SearchKeywordResult.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 9/27/24.
//

import Foundation

struct SearchKeywordResult: Codable {
    let categories: [KeywordCategory]
}

struct KeywordCategory: Codable {
    let categoryName: String
    let categoryImage: String
    let keywords: [KeywordData]
}

struct KeywordData: Codable {
    let keywordId: Int
    let keywordName: String
}
