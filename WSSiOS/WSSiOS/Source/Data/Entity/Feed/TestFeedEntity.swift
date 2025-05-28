//
//  TestFeedEntity.swift
//  WSSiOS
//
//  Created by 신지원 on 5/29/25.
//

import Foundation

struct TestFeedEntity {
    // 피드 작성 유저 관련
    let userId: Int
    let userNickname: String
    let userProfileImageURL: URL?
    
    // 피드 관련
    let feedId: Int
    let createdDate: String
    let feedContent: String
    let likeCount: Int
    let isLiked: Bool
    let commentCount: Int
    let genreCategories: [String]
    
    // 피드 연결 작품 관련
    let hasLinkedNovel: Bool
    let novelId: Int
    let novelTitle: String
    let novelRating: Float
    let hasUserRating: Bool
    let novelUserRating: Float
    let novelAuthor: String
    let novelGenre: String
    let novelDescription: String
    let novelThumbnailURL: URL?
    
    let isSpoiler: Bool
    let isModified: Bool
    let isMyFeed: Bool
    let isPublic: Bool
    
    // 피드 첨부 이미지 관련
    let hasImage: Bool
    let imageCount: Int
    let imageURLs: [URL?]
}
