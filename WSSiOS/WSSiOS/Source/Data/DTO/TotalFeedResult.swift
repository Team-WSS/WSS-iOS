//
//  TotalFeedDTO.swift
//  WSSiOS
//
//  Created by 신지원 on 5/15/24.
//

import Foundation

struct TotalFeed: Codable {
    let category: String
    let isLoadable: Bool
    let feeds: [TotalFeeds]
}

struct TotalFeeds: Codable {
    let userId: Int
    let nickname: String
    let avatarImage: String
    let feedId: Int
    let createdDate: String
    let feedContent: String
    let likeCount: Int
    let isLiked: Bool
    let commentCount: Int
    let novelId: Int
    let title: String
    let novelRatingCount: Int
    let novelRating: Float
    let relevantCategories: [String]
    let isSpolier: Bool
    let isModified: Bool
    let isMyFeed: Bool
}
