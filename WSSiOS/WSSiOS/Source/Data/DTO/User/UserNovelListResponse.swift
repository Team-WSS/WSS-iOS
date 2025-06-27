//
//  UserNovelResponse.swift
//  WSSiOS
//
//  Created by 신지원 on 1/17/24.
//

import Foundation

struct UserNovelListResponse: Decodable {
    let userNovelCount: Int
    let isLoadable: Bool
    let userNovels: [UserNovelResponse]
}

struct UserNovelResponse: Decodable {
    let userNovelId: Int
    let novelId: Int
    let title: String
    let novelImage: String
    let novelRating: Float
    let readStatus: String?
    let isInterest: Bool
    let userNovelRating: Float
    let attractivePoints: [String]
    let startDate: String?
    let endDate: String?
    let keywords: [String]
    let myFeeds: [String]
}
