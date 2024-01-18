//
//  RecommendResult.swift
//  WSSiOS
//
//  Created by 최서연 on 1/16/24.
//

import Foundation

struct SosopickNovels: Codable {
    let sosoPickNovels: [SosopickNovel]
}

struct SosopickNovel: Codable {
    let novelId: Int
    let novelImage: String
    let novelTitle: String
    let novelAuthor: String
    let novelRegisteredCount: Int
    
    enum CodingKeys: String, CodingKey {
        case novelId
        case novelImage = "novelImg"
        case novelTitle
        case novelAuthor
        case novelRegisteredCount
    }
}
