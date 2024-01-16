//
//  UserNovelResult.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 1/15/24.
//

import Foundation

// MARK: - UserNovel

struct UserNovelDetail: Codable {
    let memos: [UserNovelMemo]
    let userNovelTitle: String
    let userNovelImg: String
    let userNovelAuthor: String
    let userNovelRating: Float
    let userNovelReadStatus: String
    let userNovelReadStartDate: String?
    let userNovelReadEndDate: String?
    let userNovelDescription: String
    let userNovelGenre: String
    let userNovelGenreBadgeImg: String
    let platforms: [UserNovelPlatform]
}

// MARK: - UserNovelMemo

struct UserNovelMemo: Codable {
    let memoId: Int
    let memoContent: String
    let createdDate: String
}

// MARK: - UserNovelPlatform

struct UserNovelPlatform: Codable {
    let platformName: String
    let platformUrl: String
}

// MARK: - UserNovelBasic
struct UserNovelBasicInfo: Codable {
    let userNovelRating: Float?
    let userNovelReadStatus: String
    let userNovelReadStartDate, userNovelReadEndDate: String?
}

struct UserNovelId: Codable {
    let userNovelId: Int
}
