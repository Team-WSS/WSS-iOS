//
//  NovelReviewResult.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 9/27/24.
//

import Foundation

struct NovelReviewResponse: Decodable {
    let novelTitle: String
    let status: String?
    let startDate: String?
    let endDate: String?
    let userNovelRating: Float
    let attractivePoints: [String]
    let keywords: [KeywordData]
}

struct PostNovelReviewRequest: Encodable {
    let novelId: Int
    let userNovelRating: Float
    let status: String
    let startDate: String?
    let endDate: String?
    let attractivePoints: [String]
    let keywordIds: [Int]
}

struct PutNovelReviewRequest: Encodable {
    let userNovelRating: Float
    let status: String
    let startDate: String?
    let endDate: String?
    let attractivePoints: [String]
    let keywordIds: [Int]
}
