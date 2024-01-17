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
    let novelImg: String
}
