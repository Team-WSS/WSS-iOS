//
//  UserNovelListRequest.swift
//  WSSiOS
//
//  Created by 신지원 on 1/17/24.
//

import Foundation

struct UserNovelList: Codable {
    let userNovelCount: Int64
    let userNovelRating: Float
    let isLoadable: Bool
    let userNovels: [UserNovel]
}

struct UserNovel: Codable {
    let userNovelId: Int64
    let novelId: Int64
    let author: String
    let novelImage: String
    let title: String
    let novelRating: Float
}

struct ShowNovelStatus {
    let readStatus: String
    let lastUserNovelId: Int
    let size: Int
    let sortType: String
}
