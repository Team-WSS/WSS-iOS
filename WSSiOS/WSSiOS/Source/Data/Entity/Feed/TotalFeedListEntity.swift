//
//  TotalFeedEntity.swift
//  WSSiOS
//
//  Created by 신지원 on 3/4/25.
//

import Foundation
import UIKit

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
    let avatarImage: URL?
    let createdDate: String
    let feedContent: String
    let likeCount: Int
    let isLiked: Bool
    let commentCount: Int
    
    let novelId: Int
    let title: String
    let novelGenreColor: UIColor
    let novelGenreImage: UIImage
    let feedWriterNovelRating: Float
    
    let relevantCategories: String
    let isSpoiler: Bool
    let isModified: Bool
    let isMyFeed: Bool
    let isPublic: Bool

    let thumbnailImageURL: URL?
    let hasImage: Bool
    let imageCount: Int
}

extension TotalFeedListEntity {
    static func from(userFeedListEntity: UserFeedListEntity, myProfileEntity: MyProfileEntity, userId: Int) -> TotalFeedListEntity {
        TotalFeedListEntity(
            category: "all",
            isLoadable: userFeedListEntity.isLoadable,
            feeds: userFeedListEntity.feeds.map {
                TotalFeedEntity(
                    feedId: $0.feedId,
                    userId: userId,
                    nickname: myProfileEntity.nickname,
                    avatarImage: myProfileEntity.avatarImageURL,
                    createdDate: $0.createdDate,
                    feedContent: $0.feedContent,
                    likeCount: $0.likeCount,
                    isLiked: $0.isLiked,
                    commentCount: $0.commentCount,
                    novelId: $0.novelId,
                    title: $0.title,
                    novelGenreColor: $0.novelGenreColor,
                    novelGenreImage: $0.novelGenreImage,
                    feedWriterNovelRating: $0.feedWriterNovelRating,
                    relevantCategories: $0.relevantCategories.joined(separator: ", "),
                    isSpoiler: $0.isSpoiler,
                    isModified: $0.isModified,
                    isMyFeed: true,
                    isPublic: $0.isPublic,
                    thumbnailImageURL: URL(string: $0.thumbnailImage ?? ""),
                    hasImage: $0.hasImage,
                    imageCount: $0.imageCount)
            })
    }
}

extension TotalFeedResponse {
    func toEntity() -> TotalFeedEntity {
        let avatarImageURL = KingFisherRxHelper.makeImageURLString(path: self.avatarImage)
        let categoryText = self.relevantCategories.joined(separator: ", ")
        let roundedRating: Float
        if let userNovelRating = self.feedWriterNovelRating {
            roundedRating = round(userNovelRating * 10) / 10
        } else {
            roundedRating = -1
        }
        
        let thumbnailImageURL = URL(string: self.thumbnailUrl ?? "")
        let hasImage = self.thumbnailUrl != nil && self.imageCount > 0
        
        let genre = NewNovelGenre(rawValue: self.genreName ?? "")
        let novelGenreColor = genre?.linkColor ?? .genreColorR
        let novelGenreImage = genre?.linkImage ?? .icGenreLinkR
        
        return TotalFeedEntity(
            feedId: self.feedId,
            userId: self.userId,
            nickname: self.nickname,
            avatarImage: avatarImageURL,
            createdDate: self.createdDate,
            feedContent: self.feedContent,
            likeCount: self.likeCount,
            isLiked: self.isLiked,
            commentCount: self.commentCount,
            novelId: self.novelId ?? -1,
            title: self.title ?? "",
            novelGenreColor: novelGenreColor,
            novelGenreImage: novelGenreImage,
            feedWriterNovelRating: roundedRating,
            relevantCategories: categoryText,
            isSpoiler: self.isSpoiler,
            isModified: self.isModified,
            isMyFeed: self.isMyFeed,
            isPublic: self.isPublic,
            thumbnailImageURL: thumbnailImageURL,
            hasImage: hasImage,
            imageCount: self.imageCount
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
                                                                    avatarImage: nil,
                                                                    createdDate: "10월 4일",
                                                                    feedContent: "안녕 테스트 레포지토리야",
                                                                    likeCount: 12,
                                                                    isLiked: false,
                                                                    commentCount: 23,
                                                                    novelId: 234,
                                                                    title: "바보야",
                                                                    novelGenreColor: .genreColorBL,
                                                                    novelGenreImage: .icGenreLinkBL,
                                                                    feedWriterNovelRating: 3.33,
                                                                    relevantCategories: "없을걸",
                                                                    isSpoiler: false,
                                                                    isModified: false,
                                                                    isMyFeed: true,
                                                                    isPublic: true,
                                                                    thumbnailImageURL: URL(string: "https://i.pinimg.com/736x/38/7c/11/387c11814df12d9b28d64d0af942c679.jpg")!,
                                                                    hasImage: true,
                                                                    imageCount: 12),
                                                    TotalFeedEntity(feedId: 123123,
                                                                    userId: 31313131,
                                                                    nickname: "구리",
                                                                    avatarImage: nil,
                                                                    createdDate: "10월 3일",
                                                                    feedContent: "이번엔 소설이 없고 이미지가 있어요",
                                                                    likeCount: 12,
                                                                    isLiked: false,
                                                                    commentCount: 23,
                                                                    novelId: -1,
                                                                    title: "",
                                                                    novelGenreColor: .genreColorBL,
                                                                    novelGenreImage: .icGenreLinkBL,
                                                                    feedWriterNovelRating: 3.33,
                                                                    relevantCategories: "없을걸",
                                                                    isSpoiler: false,
                                                                    isModified: false,
                                                                    isMyFeed: false,
                                                                    isPublic: true,
                                                                    thumbnailImageURL: URL(string: "https://i.pinimg.com/736x/38/7c/11/387c11814df12d9b28d64d0af942c679.jpg")!,
                                                                    hasImage: true,
                                                                    imageCount: 3),
                                                    TotalFeedEntity(feedId: 123123,
                                                                    userId: 31313131,
                                                                    nickname: "구림",
                                                                    avatarImage: nil,
                                                                    createdDate: "10월 3일",
                                                                    feedContent: "이번엔 이미지 없음",
                                                                    likeCount: 12,
                                                                    isLiked: false,
                                                                    commentCount: 23,
                                                                    novelId: 234,
                                                                    title: "바보야",
                                                                    novelGenreColor: .genreColorBL,
                                                                    novelGenreImage: .icGenreLinkBL,
                                                                    feedWriterNovelRating: 3.33,
                                                                    relevantCategories: "없을걸",
                                                                    isSpoiler: false,
                                                                    isModified: false,
                                                                    isMyFeed: false,
                                                                    isPublic: true,
                                                                    thumbnailImageURL: URL(string: "https://i.pinimg.com/736x/38/7c/11/387c11814df12d9b28d64d0af942c679.jpg")!,
                                                                    hasImage: false,
                                                                    imageCount: 0),
                                                    TotalFeedEntity(feedId: 123123,
                                                                    userId: 31313131,
                                                                    nickname: "구리",
                                                                    avatarImage: nil,
                                                                    createdDate: "10월 3일",
                                                                    feedContent: "이번엔 소설이 없군",
                                                                    likeCount: 12,
                                                                    isLiked: false,
                                                                    commentCount: 23,
                                                                    novelId: -1,
                                                                    title: "",
                                                                    novelGenreColor: .genreColorBL,
                                                                    novelGenreImage: .icGenreLinkBL,
                                                                    feedWriterNovelRating: -1,
                                                                    relevantCategories: "없을걸",
                                                                    isSpoiler: false,
                                                                    isModified: false,
                                                                    isMyFeed: false,
                                                                    isPublic: true,
                                                                    thumbnailImageURL: URL(string: "https://i.pinimg.com/736x/38/7c/11/387c11814df12d9b28d64d0af942c679.jpg")!,
                                                                    hasImage: false,
                                                                    imageCount: 0)
                                                   ])
}
