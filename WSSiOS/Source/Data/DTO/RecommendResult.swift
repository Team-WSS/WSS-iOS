//
//  RecommendResult.swift
//  WSSiOS
//
//  Created by 최서연 on 1/16/24.
//

import Foundation

// 오늘의 발견
struct TodayDiscoveryNovels: Decodable {
    var popularNovels: [TodayDiscoveryNovel]
}

struct TodayDiscoveryNovel: Decodable {
    let novelId: Int
    let title: String
    let novelImage: String
    let avatarImage: String?
    let nickname: String?
    let feedContent: String?
    let author: String
    let isNovelCompleted: Bool
    let genreName: String
    let keywords: [String]
    let novelDescription: String
    // TODO: - 필드 삭제 예정
    let novelGenres: [String]
}

// 지금 뜨는 수다글
struct RealtimePopularFeeds: Decodable {
    var popularFeeds: [RealtimePopularFeed]
}

struct RealtimePopularFeed: Decodable {
    let feedId: Int
    let feedContent: String
    let likeCount: Int
    let commentCount: Int
    let isSpoiler: Bool
    let isPublic: Bool

    let novelTitle: String
    let novelImage: String
    let novelGenre: String
}

// 관심글
struct InterestFeeds: Codable {
    var recommendFeeds: [InterestFeed]
    var message: String
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

enum InterestMessage: String {
    case noInterestNovels = "NO_INTEREST_NOVELS"
    case noAssociatedFeeds = "NO_ASSOCIATED_FEEDS"
    case none = ""
}

// 선호 장르 추천
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
