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

// 삭제 예정
struct RecordMemos: Decodable {
    let memoCount: Int
    let memos: [RecordMemo]
}

struct RecordMemo: Codable {
    let id: Int
    let novelTitle: String
    let content: String
    let date: String
    
    enum CodingKeys: String, CodingKey {
        case id = "memoId"
        case novelTitle
        case content = "memoContent"
        case date = "memoDate"
    }
}
