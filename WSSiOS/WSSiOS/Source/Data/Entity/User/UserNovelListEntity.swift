//
//  UserNovelEntity.swift
//  WSSiOS
//
//  Created by 신지원 on 3/4/25.
//

import Foundation

struct UserNovelListEntity {
    let userNovelCount: Int
    let isLoadable: Bool
    let userNovels: [UserNovelEntity]
}

extension UserNovelListResponse {
    func toEntity() -> UserNovelListEntity {
        return UserNovelListEntity(userNovelCount: self.userNovelCount,
                                   isLoadable: self.isLoadable,
                                   userNovels: self.userNovels.map { $0.toEntity() })
    }
}

struct UserNovelEntity {
    let userNovelId: Int
    let novelId: Int
    let title: String
    let novelImage: String
    let novelRating: Float
    let readStatus: ReadStatus?
    let isInterest: Bool
    let userNovelRating: Float
    let attractivePoints: [AttractivePoint?]
    let startDate: String?
    let endDate: String?
    let keywords: [String]
    let myFeeds: [String]
}

extension UserNovelResponse {
    func toEntity() -> UserNovelEntity {
        let readStatus = ReadStatus(rawValue: self.readStatus ?? "")
        let attractivePoints = attractivePoints.map { AttractivePoint(rawValue: $0) }
        
        return UserNovelEntity(
            userNovelId: self.userNovelId,
                               novelId: self.novelId,
                               title: self.title,
            novelImage: self.novelImage,
            novelRating: self.novelRating,
            readStatus: readStatus,
            isInterest: self.isInterest,
            userNovelRating: self.userNovelRating,
            attractivePoints: attractivePoints,
            startDate: self.startDate,
            endDate: self.endDate,
            keywords: self.keywords,
            myFeeds: self.myFeeds
        )
    }
}

struct UserNovelNovelStatus {
    let readStatus: String
    let lastUserNovelId: Int
    let size: Int
    let sortType: String
}
