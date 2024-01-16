//
//  RecommendResult.swift
//  WSSiOS
//
//  Created by 최서연 on 1/16/24.
//

import Foundation

struct SosopickNovels {
    let sosopickList: [SosopickNovel]
}

struct SosopickNovel {
    let novelImage: String
    let novelTitle: String
    let novelAuthor: String
    let novelRegisteredCount: Int
}
