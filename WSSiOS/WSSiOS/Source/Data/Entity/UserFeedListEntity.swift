//
//  MyFeedListEntity.swift
//  WSSiOS
//
//  Created by 신지원 on 3/19/25.
//

import Foundation

struct UserFeedListEntity {
    let isLoadable: Bool
    let feeds: [UserFeedEntity]
}

extension UserFeedListResponse {
    func toEntity() -> UserFeedListEntity {
        return UserFeedListEntity(isLoadable: self.isLoadable,
                                feeds: self.feeds.map { $0.toEntity()} )
    }
}

struct UserFeedEntity {
    let feedId: Int
    let feedContent: String
    let createdDate: String
    let isSpoiler: Bool
    let isModified: Bool
    let isLiked: Bool
    let likeCount: Int
    let commentCount: Int
    let novelId: Int
    let title: String
    let novelRating: Float
    let novelRatingCount: Int
    let relevantCategories: [String]
    let isPublic: Bool
    
    let thumbnailImage: String
    let hasImage: Bool
    let imageCount: Int
}

extension UserFeedResponse {
    func toEntity() -> UserFeedEntity {
        let makeNovelRating: Float
        if let novelRating = self.novelRating {
            makeNovelRating = round(novelRating * 10) / 10
        } else {
            makeNovelRating = -1
        }
        
        let translatedGenres = self.relevantCategories.compactMap {
            NewNovelGenre(rawValue: $0)?.withKorean
        }
        
        return UserFeedEntity(feedId: self.feedId,
                            feedContent: self.feedContent,
                            createdDate: self.formattedDate(),
                            isSpoiler: self.isSpoiler,
                            isModified: self.isModified,
                            isLiked: self.isLiked,
                            likeCount: self.likeCount,
                            commentCount: self.commentCount,
                            novelId: self.novelId ?? -1,
                            title: self.title ?? "",
                            novelRating: makeNovelRating,
                            novelRatingCount: self.novelRatingCount ?? -1,
                            relevantCategories: translatedGenres,
                            isPublic: isPublic,
                            thumbnailImage: "",
                            hasImage: true,
                            imageCount: 20)
    }
    
    private func formattedDate() -> String {
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = inputDateFormatter.date(from: self.createdDate) else {
            return ""
        }
        
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.locale = Locale(identifier: "ko_KR")
        outputDateFormatter.dateFormat = "M월 d일"
        
        return outputDateFormatter.string(from: date)
    }
}

struct UserFeedListItem {
    let feed: UserFeedEntity
    let avatarImage: URL?
    let nickname: String
}
