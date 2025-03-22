//
//  NovelReviewEntity.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 3/23/25.
//

import Foundation

struct NovelReviewEntity {
    let novelTitle: String
    let status: String?
    let startDate: Date?
    let endDate: Date?
    let userNovelRating: Float
    let attractivePoints: [String]
    let keywords: [KeywordData]
}

extension NovelReviewResponse {
    func toEntity() -> NovelReviewEntity {
        let dateFormatter = DateFormatter().then {
            $0.dateFormat = "yyyy-MM-dd"
            $0.timeZone = TimeZone(identifier: "ko_KR")
        }
        
        let startDate = self.startDate.flatMap { dateFormatter.date(from: $0) }
        let endDate = self.endDate.flatMap { dateFormatter.date(from: $0) }
        return NovelReviewEntity(novelTitle: self.novelTitle,
                                 status: self.status,
                                 startDate: startDate,
                                 endDate: endDate,
                                 userNovelRating: self.userNovelRating,
                                 attractivePoints: self.attractivePoints,
                                 keywords: self.keywords)
    }
}
