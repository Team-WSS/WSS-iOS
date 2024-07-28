//
//  FeedDetailResult.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 6/24/24.
//

import Foundation

/// 소소피드 전체 및 단건 조회
struct Feed {
    var userId: Int
    var userNickName: String
    var userProfileImage: String
    
    var createdDate: String
    var feedContent: String
    var likeCount: Int
    var isLiked: Bool
    
    var novelId: Int
    var novelTitle: String
    var novelRatingCount: Int
    var novelRating: Float
    var genres: [NovelGenre]
    
    var isSpoiler: Bool
    var isModified: Bool
    var isMyFeed: Bool
}

/// 소소피드 댓글 전체 조회
struct FeedComment {
    var commentCount: Int
    var comments: [Comment]
}

struct Comment {
    var userId: Int
    var userNickname: String
    var userProfileImage: String
    var commentId: Int
    var createdDate: String
    var commentContent: String
    var isModified: Bool
    var isMyComment: Bool
}
