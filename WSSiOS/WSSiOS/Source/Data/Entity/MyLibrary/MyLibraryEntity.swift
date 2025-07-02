//
//  MyLibraryEntity.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 6/27/25.
//

import Foundation

struct MyLibraryListEntity {
    var userNovelCount: Int
    var isLoadable: Bool
    var userNovels: [MyLibraryEntity]
}

extension MyLibraryListResponse {
    func toEntity() -> MyLibraryListEntity {
        return MyLibraryListEntity(userNovelCount: self.userNovelCount,
                                   isLoadable: self.isLoadable,
                                   userNovels: self.userNovels.map { $0.toEntity() })
    }
}

struct MyLibraryEntity {
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

extension MyLibraryResponse {
    func toEntity() -> MyLibraryEntity {
        let readStatus = ReadStatus(rawValue: self.readStatus ?? "")
        let attractivePoints = attractivePoints.map { AttractivePoint(rawValue: $0) }
        
        return MyLibraryEntity(
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
