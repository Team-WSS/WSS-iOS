//
//  NovelMemoResult.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 1/16/24.
//

import Foundation

struct MemoContent: Codable {
    let memoContent: String
}

struct FeedContent: Codable {
    let relevantCategories: [String]
    let feedContent: String
    let novelId: Int?
    let isSpoiler: Bool
}

struct IsAvatarUnlocked: Codable {
    let isAvatarUnlocked: Bool
}

struct MemoDetail: Codable {
    let userNovelTitle: String
    let userNovelImg: String
    let userNovelAuthor: String
    let memoDate: String
    let memoContent: String
}
