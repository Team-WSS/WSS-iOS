//
//  FeedResponse.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 6/24/24.
//

import Foundation

/// 소소피드 전체 및 단건 조회
struct FeedResponse: Decodable {
    var userId: Int
    var nickname: String
    var avatarImage: String
    
    var feedId: Int
    var createdDate: String
    var feedContent: String
    var likeCount: Int
    var isLiked: Bool
    
    var commentCount: Int
    
    var novelId: Int?
    var title: String?
    var novelRatingCount: Int?
    var novelRating: Float?
    var relevantCategories: [String]
    
    var isSpoiler: Bool
    var isModified: Bool
    var isMyFeed: Bool
}

/// 소소피드 댓글 전체 조회
struct FeedCommentsResponse: Decodable {
    var commentsCount: Int
    var comments: [FeedCommentResponse]
}

struct FeedCommentResponse: Decodable {
    var userId: Int
    var nickname: String
    var avatarImage: String
    var commentId: Int
    var createdDate: String
    var commentContent: String
    var isModified: Bool
    var isMyComment: Bool
    var isSpoiler: Bool
    var isBlocked: Bool
    var isHidden: Bool
}
