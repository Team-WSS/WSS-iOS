//
//  TotalFeedEntity.swift
//  WSSiOS
//
//  Created by 신지원 on 3/4/25.
//

struct TotalFeedListEntity {
    let category: String
    let isLoadable: Bool
    let feeds: [TotalFeedEntity]
}

extension TotalFeedListResponse {
    func toEntity() -> TotalFeedListEntity {
        return TotalFeedListEntity(category: self.category,
                               isLoadable: self.isLoadable,
                               feeds: self.feeds.map { $0.toEntity() })
    }
}

struct TotalFeedEntity {
    let feedId: Int
    let userId: Int
    let nickname: String
    let avatarImage: String
    let createdDate: String
    let feedContent: String
    let likeCount: Int
    let isLiked: Bool
    let commentCount: Int
    let novelId: Int
    let title: String
    let novelRatingCount: Int
    let novelRating: Float
    let relevantCategories: String
    let isSpoiler: Bool
    let isModified: Bool
    let isMyFeed: Bool
}

extension TotalFeedResponse {
    func toEntity() -> TotalFeedEntity {
        let categoryText = self.relevantCategories.joined(separator: ", ")
        
        return TotalFeedEntity(
            feedId: self.feedId,
            userId: self.userId,
            nickname: self.nickname,
            avatarImage: self.avatarImage,
            createdDate: self.createdDate,
            feedContent: self.feedContent,
            likeCount: self.likeCount,
            isLiked: self.isLiked,
            commentCount: self.commentCount,
            novelId: self.novelId ?? -1,
            title: self.title ?? "",
            novelRatingCount: self.novelRatingCount ?? -1,
            novelRating: self.novelRating ?? -1,
            relevantCategories: categoryText,
            isSpoiler: self.isSpoiler,
            isModified: self.isModified,
            isMyFeed: self.isMyFeed
        )
    }
}
