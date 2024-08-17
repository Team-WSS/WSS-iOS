//
//  RecommendResult.swift
//  WSSiOS
//
//  Created by 최서연 on 1/16/24.
//

import Foundation

struct TodayPopularNovel {
    var novelId: Int
    var title: String
    var novelImage: String
    var avatarImage: String
    var nickname: String
    var feedContent: String
}

struct RealtimePopularFeed {
    var feedId: Int
    var feedContent: String
    var feedLikeCount: Int
    var feedCommentCount: Int
}

struct InterestFeed {
    var novelId: Int
    var novelTitle: String
    var novelImage: String
    var novelRating: Float
    var novelRatingCount: Int
    var userNickname: String
    var userAvatarImage: String
    var userFeedContent: String
}

struct TasteRecommendNovel {
    var novelId: Int
    var novelTitle: String
    var novelAuthor: String
    var novelImage: String
    var novelLikeCount: Int
    var novelRating: Float
    var novelRatingCount: Int
}

