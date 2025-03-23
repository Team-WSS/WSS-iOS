//
//  FeedEntity.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 3/22/25.
//

import Foundation

struct FeedEntity {
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
    let novelId: Int?
    let novelTitle: String?
    let novelRatingCount: Int?
    let novelRating: Float?
    
    let isSpoiler: Bool
    let isModified: Bool
    let isMyFeed: Bool
}

extension FeedResponse {
    func toEntity() -> FeedEntity {
        let userProfileImageURL = KingFisherRxHelper.makeImageURLString(path: self.avatarImage)
        let hasLinkedNovel = self.novelId != nil
        
        return FeedEntity(userId: self.userId,
                          userNickname: self.nickname,
                          userProfileImageURL: userProfileImageURL,
                          feedId: self.feedId,
                          createdDate: self.createdDate,
                          feedContent: self.feedContent,
                          likeCount: self.likeCount,
                          isLiked: self.isLiked,
                          commentCount: self.commentCount,
                          genreCategories: self.relevantCategories,
                          hasLinkedNovel: hasLinkedNovel,
                          novelId: self.novelId,
                          novelTitle: self.title,
                          novelRatingCount: self.novelRatingCount,
                          novelRating: self.novelRating,
                          isSpoiler: self.isSpoiler,
                          isModified: self.isModified,
                          isMyFeed: self.isMyFeed)
    }
}
