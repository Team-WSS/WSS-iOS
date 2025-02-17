//
//  NovelDetailHeaderEntity.swift
//  WSSiOS
//
//  Created by YunhakLee on 9/22/24.
//

import UIKit

import RxSwift

struct NovelDetailHeaderEntity {
    let userNovelID: Int?
    let novelTitle: String
    let novelImage: String
    let novelGenre: String
    let novelGenreImage: String
    let isNovelCompleted: Bool
    let novelAuthor: String
    let interestCount: Int
    let novelRating: Float
    let novelRatingCount: Int
    let feedCount: Int
    let isUserNovelRatingExist: Bool
    let userNovelRating: Float
    let readStatus: ReadStatus?
    let isReadDateExist: Bool
    let startDate: String?
    let endDate: String?
    let isUserNovelInterest: Bool
}

extension NovelDetailHeaderResponse {
    func toEntity() -> NovelDetailHeaderEntity {
        return NovelDetailHeaderEntity(
            userNovelID: self.userNovelID,
            novelTitle: self.novelTitle,
            novelImage: self.novelImage,
            novelGenre: self.novelGenres,
            novelGenreImage: self.novelGenreImage,
            isNovelCompleted: self.isNovelCompleted,
            novelAuthor: self.author,
            interestCount: self.interestCount,
            novelRating: round(self.novelRating * 10) / 10,
            novelRatingCount: self.novelRatingCount,
            feedCount: self.feedCount,
            isUserNovelRatingExist: !self.userNovelRating.isZero,
            userNovelRating: round(self.userNovelRating * 10) / 10,
            readStatus: ReadStatus(rawValue: readStatus ?? ""),
            isReadDateExist: self.startDate != nil || self.endDate != nil,
            startDate: self.startDate,
            endDate: self.endDate,
            isUserNovelInterest: self.isUserNovelInterest
        )
    }
}
