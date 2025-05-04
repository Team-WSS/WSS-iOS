//
//  MyFeedListEntity.swift
//  WSSiOS
//
//  Created by 신지원 on 3/19/25.
//

import Foundation

struct MyFeedListEntity {
    let isLoadable: Bool
    let feeds: [MyFeedEntity]
}

extension MyFeedListResponse {
    func toEntity() -> MyFeedListEntity {
        return MyFeedListEntity(isLoadable: self.isLoadable,
                                feeds: self.feeds.map { $0.toEntity()} )
    }
}

struct MyFeedEntity {
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
}

extension MyFeedResponse {
    func toEntity() -> MyFeedEntity {
        let makeNovelRating: Float
        if let novelRating = self.novelRating {
            makeNovelRating = round(novelRating * 10) / 10
        } else {
            makeNovelRating = -1
        }
        
        let translatedGenres = self.relevantCategories.compactMap {
            NewNovelGenre(rawValue: $0)?.withKorean
        }
        
        return MyFeedEntity(feedId: self.feedId,
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
                            isPublic: isPublic)
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

struct MyFeedListItem {
    let feed: MyFeedEntity
    let avatarImage: String
    let nickname: String
}
