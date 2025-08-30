//
//  UserNovelResponse.swift
//  WSSiOS
//
//  Created by 신지원 on 1/17/24.
//

import Foundation

struct UserNovelListResponse: Decodable {
    let userNovelCount: Int
    let isLoadable: Bool
    let userNovels: [UserNovelResponse]
}

struct UserNovelResponse: Decodable {
    let userNovelId: Int
    let novelId: Int
    let author: String
    let novelImage: String
    let title: String
    let novelRating: Float
}
