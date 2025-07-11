//
//  MyFeedListEntity.swift
//  WSSiOS
//
//  Created by 신지원 on 3/19/25.
//

import Foundation
import UIKit

struct UserFeedListEntity {
    let isLoadable: Bool
    let feedsCount: Int
    let feeds: [UserFeedEntity]
}

extension UserFeedListResponse {
    func toEntity() -> UserFeedListEntity {
        return UserFeedListEntity(isLoadable: self.isLoadable,
                                  feedsCount: self.feedsCount,
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
    
    let novelGenreColor: UIColor
    let novelGenreImage: UIImage
    let userNovelRating: Float
    
    let relevantCategories: [String]
    let isPublic: Bool
    
    let thumbnailImage: String?
    let hasImage: Bool
    let imageCount: Int
}

extension UserFeedResponse {
    func toEntity() -> UserFeedEntity {
        let roundedRating: Float
        if let userNovelRating = self.userNovelRating {
            roundedRating = round(userNovelRating * 10) / 10
        } else {
            roundedRating = -1
        }
        
        let hasImage = self.thumbnailUrl != nil && self.imageCount > 0
        let translatedGenres = self.relevantCategories.compactMap {
            NewNovelGenre(rawValue: $0)?.withKorean
        }
        
        let genre = NewNovelGenre(rawValue: self.genre ?? "")
        let novelGenreColor = genre?.linkColor ?? .genreColorR
        let novelGenreImage = genre?.linkImage ?? .icGenreLinkR
        
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
                              novelGenreColor: novelGenreColor,
                              novelGenreImage: novelGenreImage,
                              userNovelRating: roundedRating,
                              relevantCategories: translatedGenres,
                              isPublic: isPublic,
                              thumbnailImage: self.thumbnailUrl,
                              hasImage: hasImage,
                              imageCount: self.imageCount)
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
