//
//  MemoDTO.swift
//  WSSiOS
//
//  Created by 최서연 on 1/15/24.
//

import Foundation

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
