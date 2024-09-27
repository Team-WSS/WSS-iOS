//
//  NovelReviewResult.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 9/27/24.
//

import Foundation

struct NovelReviewResult: Codable {
    let novelTitle: String
    let status: String?
    let startDate: String?
    let endDate: String?
    let userNovelRating: Float
    let attractivePoints: [String]
    let keywords: [KeywordData]
}

struct KeywordData: Codable {
    let keywordId: Int
    let keywordName: String
}

struct PostNovelReviewContent: Codable {
    let novelId: Int
    let userNovelRating: Float
    let status: String
    let startDate: String?
    let endDate: String?
    let attractivePoints: [String]
    let keywordIds: [Int]
}

struct PutNovelReviewContent: Codable {
    let userNovelRating: Float
    let status: String
    let startDate: String?
    let endDate: String?
    let attractivePoints: [String]
    let keywordIds: [Int]
}
