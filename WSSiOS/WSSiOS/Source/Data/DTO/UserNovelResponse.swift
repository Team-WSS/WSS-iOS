//
//  UserNovelResponse.swift
//  WSSiOS
//
//  Created by 신지원 on 1/17/24.
//

import Foundation

struct UserNovelResponse: Decodable {
    let userNovelCount: Int
    let userNovelRating: Float
    let isLoadable: Bool
    let userNovels: [UserNovelListDTO]
}

struct UserNovelListDTO: Decodable {
    let userNovelId: Int
    let novelId: Int
    let author: String
    let novelImage: String
    let title: String
    let novelRating: Float
}
