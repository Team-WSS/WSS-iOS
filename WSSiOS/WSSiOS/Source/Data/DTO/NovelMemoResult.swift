//
//  NovelMemoResult.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 1/16/24.
//

import Foundation

// MARK: - MemoContent: Codable {

struct MemoContent: Codable {
    let memoContent: String
}

// MARK: - IsAvatarUnlocked: Codable {

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
