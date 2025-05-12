//
//  TotalFeedEntity.swift
//  WSSiOS
//
//  Created by 신지원 on 3/4/25.
//

import Foundation

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
    let isPublic: Bool

    let thumbnailImage: String
    let hasImage: Bool
    let imageCount: Int
}

extension TotalFeedResponse {
    func toEntity() -> TotalFeedEntity {
        let categoryText = self.relevantCategories.joined(separator: ", ")
        let makeNovelRating: Float
        if let novelRating = self.novelRating {
            makeNovelRating = round(novelRating * 10) / 10
        } else {
            makeNovelRating = -1
        }
        
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
            novelRating: makeNovelRating,
            relevantCategories: categoryText,
            isSpoiler: self.isSpoiler,
            isModified: self.isModified,
            isMyFeed: self.isMyFeed,
            isPublic: self.isPublic,
            //TODO: DTO 수정
            thumbnailImage: "",
            hasImage: true,
            imageCount: 20
        )
    }
}

// test repository를 위한 entity 더미 데이터
extension TotalFeedListEntity {
    static let dummyFullData = TotalFeedListEntity(category: "all",
                                                   isLoadable: true,
                                                   feeds: [
                                                    TotalFeedEntity(feedId: 10003,
                                                                    userId: 31313131,
                                                                    nickname: "최고다이순신",
                                                                    avatarImage: "",
                                                                    createdDate: "10월 4일",
                                                                    feedContent: "안녕 테스트 레포지토리야",
                                                                    likeCount: 12,
                                                                    isLiked: false,
                                                                    commentCount: 23,
                                                                    novelId: 234,
                                                                    title: "바보야",
                                                                    novelRatingCount: 23,
                                                                    novelRating: 3.33,
                                                                    relevantCategories: "없을걸",
                                                                    isSpoiler: false,
                                                                    isModified: false,
                                                                    isMyFeed: true,
                                                                    isPublic: true,
                                                                    thumbnailImage: "https://i.pinimg.com/736x/ec/af/63/ecaf63a83c5a37693a25b34f528aa9ad.jpg",
                                                                    hasImage: true,
                                                                    imageCount: 12),
                                                    TotalFeedEntity(feedId: 123123,
                                                                    userId: 31313131,
                                                                    nickname: "구리",
                                                                    avatarImage: "",
                                                                    createdDate: "10월 3일",
                                                                    feedContent: "이번엔 소설이 없고 이미지가 있어요",
                                                                    likeCount: 12,
                                                                    isLiked: false,
                                                                    commentCount: 23,
                                                                    novelId: -1,
                                                                    title: "",
                                                                    novelRatingCount: -1,
                                                                    novelRating: -1,
                                                                    relevantCategories: "없을걸",
                                                                    isSpoiler: false,
                                                                    isModified: false,
                                                                    isMyFeed: false,
                                                                    isPublic: true,
                                                                    thumbnailImage: "https://i.pinimg.com/736x/1a/51/98/1a5198477634dd2e194c02f3c8094b97.jpg",
                                                                    hasImage: true,
                                                                    imageCount: 3),
                                                    TotalFeedEntity(feedId: 123123,
                                                                    userId: 31313131,
                                                                    nickname: "구림",
                                                                    avatarImage: "",
                                                                    createdDate: "10월 3일",
                                                                    feedContent: "이번엔 이미지 없음",
                                                                    likeCount: 12,
                                                                    isLiked: false,
                                                                    commentCount: 23,
                                                                    novelId: 234,
                                                                    title: "바보야",
                                                                    novelRatingCount: 23,
                                                                    novelRating: 3.33,
                                                                    relevantCategories: "없을걸",
                                                                    isSpoiler: false,
                                                                    isModified: false,
                                                                    isMyFeed: false,
                                                                    isPublic: true,
                                                                    thumbnailImage: "https://i.pinimg.com/736x/38/7c/11/387c11814df12d9b28d64d0af942c679.jpg",
                                                                    hasImage: false,
                                                                    imageCount: 0),
                                                    TotalFeedEntity(feedId: 123123,
                                                                    userId: 31313131,
                                                                    nickname: "구리",
                                                                    avatarImage: "",
                                                                    createdDate: "10월 3일",
                                                                    feedContent: "이번엔 소설이 없군",
                                                                    likeCount: 12,
                                                                    isLiked: false,
                                                                    commentCount: 23,
                                                                    novelId: -1,
                                                                    title: "",
                                                                    novelRatingCount: -1,
                                                                    novelRating: -1,
                                                                    relevantCategories: "없을걸",
                                                                    isSpoiler: false,
                                                                    isModified: false,
                                                                    isMyFeed: false,
                                                                    isPublic: true,
                                                                    thumbnailImage: "https://i.pinimg.com/736x/5b/49/40/5b49408ec192cad6337b494b5ca4de38.jpg",
                                                                    hasImage: false,
                                                                    imageCount: 0)
                                                   ])
}
