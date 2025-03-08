//
//  UserNovelEntity.swift
//  WSSiOS
//
//  Created by 신지원 on 3/4/25.
//

import Foundation

struct UserNovelEntity {
    let userNovelCount: Int
    let userNovelRating: Float
    let isLoadable: Bool
    let userNovels: [UserNovelListEntity]
}

extension UserNovelListResponse {
    func toEntity() -> UserNovelEntity {
        return UserNovelEntity(userNovelCount: self.userNovelCount,
                               userNovelRating: self.userNovelRating,
                               isLoadable: self.isLoadable,
                               userNovels: self.userNovels.map { $0.toEntity() })
    }
}

struct UserNovelListEntity {
    let userNovelId: Int
    let novelId: Int
    let author: String
    let novelImage: String
    let title: String
    let novelRating: String
    let hasNovelRating: Bool
}

extension UserNovelResponse {
    func toEntity() -> UserNovelListEntity {
        let novelRatingText = String(round(self.novelRating * 10) / 10)
        let hasNovelRating = self.novelRating != 0.0
        
        return UserNovelListEntity(userNovelId: self.novelId,
                                   novelId: self.novelId,
                                   author: self.author,
                                   novelImage: self.novelImage,
                                   title: self.title,
                                   novelRating: novelRatingText,
                                   hasNovelRating: hasNovelRating)
    }
}

struct UserNovelNovelStatus {
    let readStatus: String
    let lastUserNovelId: Int
    let size: Int
    let sortType: String
}
