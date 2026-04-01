//
//  MyFeedReult.swift
//  WSSiOS
//
//  Created by 신지원 on 12/1/24.
//

import Foundation

struct UserFeedListResponse: Decodable {
    let isLoadable: Bool
    let feedsCount: Int
    let feeds: [UserFeedResponse]
}

struct UserFeedResponse: Decodable {
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
    let isPublic: Bool
    let genre: String?
    let feedWriterNovelRating: Float?
    let thumbnailUrl: String?
    let imageCount: Int
}
