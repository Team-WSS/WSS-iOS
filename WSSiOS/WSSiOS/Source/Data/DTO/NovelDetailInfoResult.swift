//
//  NovelDetailInfoResult.swift
//  WSSiOS
//
//  Created by 이윤학 on 6/25/24.
//

import Foundation

struct NovelDetailInfoResult: Codable {
    let novelDescription: String
    let platforms: [Platform]
    let attractivePoints: [String]
    let keywords: [Keyword]
    let watchingCount, watchedCount, quitCount: Int
}

struct Keyword: Codable {
    let keywordName: String
    let keywordCount: Int
}

struct Platform: Codable {
    let platformName, platformImage, platformURL: String
}

extension NovelDetailInfoResult {
    static let dummyData: [NovelDetailInfoResult] = []
}
