//
//  UserNovelListRequest.swift
//  WSSiOS
//
//  Created by 신지원 on 1/17/24.
//

import Foundation

struct UserNovelList: Codable {
    let userNovelCount: Int
    let userNovels: [UserNovelListDetail]
}

struct UserNovelListDetail: Codable {
    let userNovelId: Int
    let userNovelTitle: String
    let userNovelImg: String
    let userNovelAuthor: String
    let userNovelRating: Float
}

struct ShowNovelStatus {
    let readStatus: String
    let lastUserNovelId: Int
    let size: Int
    let sortType: String
}
