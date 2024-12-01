//
//  MyFeedReult.swift
//  WSSiOS
//
//  Created by 신지원 on 12/1/24.
//

import Foundation

struct MyFeedResult: Codable {
    let isLoadable: Bool
    let feeds: [MyFeed]
}

struct MyFeed: Codable {
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
}

struct FeedCellData {
    let feed: MyFeed
    let avatarImage: String
    let nickname: String
}
