//
//  SearchResult.swift
//  WSSiOS
//
//  Created by 최서연 on 1/17/24.
//

import Foundation

struct SosoPickNovel {
    var novelId: Int
    var novelImage: String
    var novelTitle: String
}

struct NormalSearchNovel {
    var novelId: Int
    var novelImage: String
    var novelTitle: String
    var novelAuthor: String
    var interestCount: Int
    var ratingAverage: Float
    var ratingCount: Int
}
