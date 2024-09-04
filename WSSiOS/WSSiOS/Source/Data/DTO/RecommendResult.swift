//
//  RecommendResult.swift
//  WSSiOS
//
//  Created by 최서연 on 1/16/24.
//

import Foundation

struct TodayPopularNovels: Codable {
    var popularNovels: [TodayPopularNovel]
}

struct TodayPopularNovel: Codable {
    var novelId: Int
    var title: String
    var novelImage: String
    var avatarImage: String?
    var nickname: String?
    var feedContent: String
}

struct RealtimePopularFeed: Codable {
    var feedId: Int
    var feedContent: String
    var feedLikeCount: Int
    var feedCommentCount: Int
}

struct InterestFeeds: Codable {
    var recommendFeeds: [InterestFeed]
}

struct InterestFeed: Codable {
    var novelId: Int
    var novelTitle: String
    var novelImage: String
    var novelRating: Float
    var novelRatingCount: Int
    var userNickname: String
    var userAvatarImage: String
    var userFeedContent: String
    
    enum CodingKeys: String, CodingKey {
        case novelId, novelTitle, novelImage, novelRating, novelRatingCount
        case userNickname = "nickname"
        case userAvatarImage = "avatarImage"
        case userFeedContent = "feedContent"
    }
}

struct TasteRecommendNovels: Codable {
    var tasteNovels: [TasteRecommendNovel]
}

struct TasteRecommendNovel: Codable {
    var novelId: Int
    var novelTitle: String
    var novelAuthor: String
    var novelImage: String
    var novelLikeCount: Int
    var novelRating: Float
    var novelRatingCount: Int
    
    enum CodingKeys: String, CodingKey {
        case novelId, novelImage, novelRating, novelRatingCount
        case novelTitle = "title"
        case novelAuthor = "author"
        case novelLikeCount = "interestCount"
    }
}
