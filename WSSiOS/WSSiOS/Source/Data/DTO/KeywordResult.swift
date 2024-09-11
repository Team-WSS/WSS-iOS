//
//  KeywordResult.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 9/10/24.
//

import Foundation

/// 상세텀색 키워드
struct DetailSearchCategories: Codable {
    var categories: [DetailSearchCategory]
}

struct DetailSearchCategory: Codable {
    var categoryName: String
    var categoryImage: String
    var keywords: [DetailSearchKeyword]
}

struct DetailSearchKeyword: Codable {
    var keywordId: Int
    var keywordName: String
}
