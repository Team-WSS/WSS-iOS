//
//  MyFeedReult.swift
//  WSSiOS
//
//  Created by 신지원 on 12/1/24.
//

import Foundation

struct MyFeedListResponse: Decodable {
    let isLoadable: Bool
    let feeds: [MyFeedResponse]
}

struct MyFeedResponse: Decodable {
    let feedId: Int
    let feedContent: String
    let createdDate: String
    let isSpoiler: Bool
    let isModified: Bool
    let likeUsers: [Int]?
    let isLiked: Bool
    let likeCount: Int
    let commentCount: Int
    let novelId: Int?
    let title: String?
    let novelRating: Float?
    let novelRatingCount: Int?
    let relevantCategories: [String]
    let isPublic: Bool
}
