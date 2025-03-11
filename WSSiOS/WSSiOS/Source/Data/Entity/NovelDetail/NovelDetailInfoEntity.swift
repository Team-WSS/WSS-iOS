//
//  NovelDetailInfoEntity.swift
//  WSSiOS
//
//  Created by YunhakLee on 2/17/25.
//

import Foundation

struct NovelDetailInfoEntity {
    let novelDescription: String
    let platforms: [PlatformEntity]
    let attractivePoints: [AttractivePoint]
    let keywords: [KeywordEntity]
    let readStatusCounts: [ReadStatus: Int]
    let topReadStatus: ReadStatus
    let topReadStatusCount: Int
    let visibilities: [ReviewSectionVisibility]
}

extension NovelDetailInfoResponse {
    func toEntity() -> NovelDetailInfoEntity {
        
        let readStatusCounts: [ReadStatus: Int] = [
            .watching: self.watchingCount,
            .watched: self.watchedCount,
            .quit: self.quitCount
        ]
        
        let topReadStatusCount = max(self.watchingCount, self.watchedCount, self.quitCount)
        let topReadStatus: ReadStatus
        
        switch topReadStatusCount {
        case self.watchingCount:
            topReadStatus = .watching
        case self.watchedCount:
            topReadStatus = .watched
        case self.quitCount:
            topReadStatus = .quit
        default:
            fatalError("Unexpected value")
        }
        
        var visibilities: [ReviewSectionVisibility] = []
        
        if (self.quitCount+self.watchedCount+self.watchingCount) > 0 {
            visibilities.append(.graph)
        }
        if !self.attractivePoints.isEmpty {
            visibilities.append(.attractivepoint)
        }
        if !self.keywords.isEmpty {
            visibilities.append(.keyword)
        }
        
        return NovelDetailInfoEntity(
            novelDescription: self.novelDescription,
            platforms: self.platforms.map { $0.toEntity() },
            attractivePoints: self.attractivePoints.compactMap { AttractivePoint(rawValue: $0) },
            keywords: self.keywords.map{ $0.toEntity() },
            readStatusCounts: readStatusCounts,
            topReadStatus: topReadStatus,
            topReadStatusCount: topReadStatusCount,
            visibilities: visibilities
        )
    }
}

struct PlatformEntity {
    let platformName: String
    let platformImage: String
    let platformURL: String
}

extension PlatformResponse {
    func toEntity() -> PlatformEntity {
        return PlatformEntity(
            platformName: self.platformName,
            platformImage: self.platformImage,
            platformURL: self.platformURL
        )
    }
}

struct KeywordEntity {
    let keywordName: String
    let keywordCount: Int
}

extension KeywordResponse {
    func toEntity() -> KeywordEntity {
        return KeywordEntity(
            keywordName: self.keywordName,
            keywordCount: self.keywordCount
        )
    }
}
