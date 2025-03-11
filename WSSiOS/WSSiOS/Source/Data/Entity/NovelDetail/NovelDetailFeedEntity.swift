//
//  NovelDetailFeedEntity.swift
//  WSSiOS
//
//  Created by 신지원 on 3/4/25.
//

import Foundation

struct NovelDetailFeedEntity {
    let isLoadable: Bool
    let feeds: [TotalFeedEntity]
}

extension NovelDetailFeedResponse {
    func toEntity() -> NovelDetailFeedEntity {
        return NovelDetailFeedEntity(isLoadable: self.isLoadable,
                               feeds: self.feeds.map { $0.toEntity() })
    }
}
