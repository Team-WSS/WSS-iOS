//
//  MyLibraryEntity.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 6/27/25.
//

import Foundation

struct MyLibraryEntity {
    var userNovelCount: Int
    var isLoadable: Bool
    var userNovels: [MyLibraryNovel]
}

extension MyLibraryListResponse {
    func toEntity() -> MyLibraryEntity {
        return MyLibraryEntity(userNovelCount: self.userNovelCount,
                                   isLoadable: self.isLoadable,
                                   userNovels: self.userNovels.map { $0.toEntity() })
    }
}

struct MyLibraryNovel {
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
    func toEntity() -> MyLibraryNovel {
        let readStatus = ReadStatus(rawValue: self.readStatus ?? "")
        let attractivePoints = attractivePoints.map { AttractivePoint(rawValue: $0) }
        
        return MyLibraryNovel(
            userNovelId: self.userNovelId,
                               novelId: self.novelId,
                               title: self.title,
            novelImage: self.novelImage,
            novelRating: self.novelRating,
            readStatus: readStatus,
            isInterest: self.isInterest,
            userNovelRating: self.userNovelRating,
            attractivePoints: attractivePoints,
            startDate:(self.startDate?.replacingOccurrences(of: "-", with: ".").dropFirst(2)).map{ String($0) },
            endDate: (self.endDate?.replacingOccurrences(of: "-", with: ".").dropFirst(2)).map{ String($0) },
            keywords: self.keywords,
            myFeeds: self.myFeeds
        )
    }
}
