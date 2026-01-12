//
//  UserNovelStatusEntity.swift
//  WSSiOS
//
//  Created by 신지원 on 5/22/25.
//

import Foundation

struct UserNovelStatusEntity {
    var interestNovelCount: Int
    var watchingNovelCount: Int
    var watchedNovelCount: Int
    var quitNovelCount: Int
}

extension UserNovelStatusResponse {
    func toEntity() -> UserNovelStatusEntity {
        return UserNovelStatusEntity(interestNovelCount: self.interestNovelCount,
                                     watchingNovelCount: self.watchingNovelCount,
                                     watchedNovelCount: self.watchedNovelCount,
                                     quitNovelCount: self.quitNovelCount)
    }
}
