//
//  NovelDetailResult.swift
//  WSSiOS
//
//  Created by 이윤학 on 4/27/24.
//

import Foundation

struct NovelDetailHeaderResult: Codable {
    let userNovelID: Int?
    let novelTitle, novelImage: String
    let novelGenres: [String]
    let novelGenreImage: String
    let isNovelCompleted: Bool
    let author: String
    let interestCount: Int
    let novelRating: Float
    let novelRatingCount, feedCount: Int
    let userNovelRating: Float
    let readStatus: String?
    let startDate, endDate: String?
    let isUserNovelInterest: Bool

    enum CodingKeys: String, CodingKey {
        case userNovelID = "userNovelId"
        case novelTitle, novelImage, novelGenres
        case novelGenreImage
        case isNovelCompleted, author, interestCount, novelRating, novelRatingCount, feedCount, userNovelRating, readStatus, startDate, endDate, isUserNovelInterest
    }
}
