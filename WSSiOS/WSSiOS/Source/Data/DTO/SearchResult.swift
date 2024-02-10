//
//  SearchResult.swift
//  WSSiOS
//
//  Created by 최서연 on 1/17/24.
//

import Foundation

struct SearchNovels: Codable {
    let novels: [SearchNovel]
}

struct SearchNovel: Codable {
    let novelId: Int
    let novelTitle: String
    let novelAuthor: String
    let novelGenre: String
    let novelImage: String
    
    enum CodingKeys: String, CodingKey {
        case novelId, novelTitle, novelAuthor, novelGenre
        case novelImage = "novelImg"
    }
}
