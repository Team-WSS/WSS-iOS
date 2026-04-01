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
    let feedWriterNovelRating: Float

    let isPublic: Bool
    
    let thumbnailImage: URL?
    let hasImage: Bool
    let imageCount: Int
}

extension UserFeedResponse {
    func toEntity() -> UserFeedEntity {
        let roundedRating: Float
        if let userNovelRating = self.feedWriterNovelRating {
            roundedRating = round(userNovelRating * 10) / 10
        } else {
            roundedRating = -1
        }
        
        let hasImage = self.thumbnailUrl != nil && self.imageCount > 0
        let genre = NewNovelGenre(rawValue: self.genre ?? "")
        let novelGenreColor = genre?.linkColor ?? .genreColorR
        let novelGenreImage = genre?.linkImage ?? .icGenreLinkR
        let thumbnailImageURL = KingFisherRxHelper.makeImageURLString(path: self.thumbnailUrl ?? "")
        
        return UserFeedEntity(feedId: self.feedId,
                              feedContent: self.feedContent,
                              createdDate: self.createdDate,
                              isSpoiler: self.isSpoiler,
                              isModified: self.isModified,
                              isLiked: self.isLiked,
                              likeCount: self.likeCount,
                              commentCount: self.commentCount,
                              novelId: self.novelId ?? -1,
                              title: self.title ?? "",
                              novelGenreColor: novelGenreColor,
                              novelGenreImage: novelGenreImage,
                              feedWriterNovelRating: roundedRating,
                              isPublic: isPublic,
                              thumbnailImage: thumbnailImageURL,
                              hasImage: hasImage,
                              imageCount: self.imageCount)
    }
}

struct UserFeedListItem {
    let feed: UserFeedEntity
    let avatarImage: URL?
    let nickname: String
}
