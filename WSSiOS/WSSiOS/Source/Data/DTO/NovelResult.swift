//
//  NovelResult.swift
//  WSSiOS
//
//  Created by 이윤학 on 1/16/24.
//

import Foundation

// MARK: - NewNovelResult

struct NovelResult: Codable {
    let newNovelResult: NewNovelResult?
    let editNovelResult: EditNovelResult?
}

struct NewNovelResult: Codable {
    let novelID: Int
    let novelTitle, novelAuthor, novelGenre, novelImg: String
    let novelDescription: String
    let platforms: [Platform]

    enum CodingKeys: String, CodingKey {
        case novelID = "novelId"
        case novelTitle, novelAuthor, novelGenre, novelImg, novelDescription, platforms
    }
}

// MARK: - Platform

struct Platform: Codable {
    let platformName, platformURL: String

    enum CodingKeys: String, CodingKey {
        case platformName
        case platformURL = "platformUrl"
    }
}

// MARK: - EditNovelResult

struct EditNovelResult: Codable {
    let userNovelID: Int
    let userNovelTitle, userNovelAuthor, userNovelGenre, userNovelImg: String
    let userNovelDescription: String
    let userNovelRating: Float?
    let userNovelReadStatus: String
    let platforms: [UserNovelPlatform]
    let userNovelReadDate: UserNovelReadDate

    enum CodingKeys: String, CodingKey {
        case userNovelID = "userNovelId"
        case userNovelTitle, userNovelAuthor, userNovelGenre, userNovelImg, userNovelDescription, userNovelRating, userNovelReadStatus, platforms, userNovelReadDate
    }
}

// MARK: - UserNovelReadDate
struct UserNovelReadDate: Codable {
    let userNovelReadStartDate, userNovelReadEndDate: String?
}

