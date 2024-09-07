//
//  SearchResult.swift
//  WSSiOS
//
//  Created by 최서연 on 1/17/24.
//

import Foundation

/// 소소픽 조회
struct SosoPickNovels: Codable {
    var sosoPicks: [SosoPickNovel]
}

struct SosoPickNovel: Codable {
    var novelId: Int
    var novelImage: String
    var novelTitle: String
    
    enum CodingKeys: String, CodingKey {
        case novelId, novelImage
        case novelTitle = "title"
    }
}

/// 일반 검색 API
struct NormalSearchNovel {
    var novelId: Int
    var novelImage: String
    var novelTitle: String
    var novelAuthor: String
    var interestCount: Int
    var ratingAverage: Float
    var ratingCount: Int
}
