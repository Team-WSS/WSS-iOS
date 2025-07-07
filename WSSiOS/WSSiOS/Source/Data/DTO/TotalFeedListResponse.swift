//
//  TotalFeedResponse.swift
//  WSSiOS
//
//  Created by 신지원 on 6/3/24.
//

import Foundation

struct TotalFeedListResponse: Decodable {
    let category: String
    let isLoadable: Bool
    let feeds: [TotalFeedResponse]
}

struct TotalFeedResponse: Decodable {
    let feedId: Int
    let userId: Int
    let nickname: String
    let avatarImage: String
    let createdDate: String
    let feedContent: String
    let likeCount: Int
    let isLiked: Bool
    let commentCount: Int
    let novelId: Int?
    let title: String?
    let novelRatingCount: Int?
    let novelRating: Float?
    let relevantCategories: [String]
    let isSpoiler: Bool
    let isModified: Bool
    let isMyFeed: Bool
    let isPublic: Bool
    
    let thumbnailUrl: String?
    let imageCount: Int
    let genreName: String?
}

struct FeedContentRequest: Encodable {
    let relevantCategories: [String]
    let feedContent: String
    let novelId: Int?
    let isSpoiler: Bool
    let isPublic: Bool
}
