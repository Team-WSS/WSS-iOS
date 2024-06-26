//
//  FeedDetailResult.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 6/24/24.
//

import Foundation

struct Feed {
    var userProfileImage: String
    var userNickName: String
    var createdDate: String
    var content: String
    var novelTitle: String
    var novelRating: Double
    var novelRatingCount: Int
    var genres: [ReplaceGenre]
    var likeCount: Int
    var commentCount: Int
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
