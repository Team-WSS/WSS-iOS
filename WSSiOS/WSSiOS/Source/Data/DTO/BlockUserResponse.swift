//
//  BlockUserResult.swift
//  WSSiOS
//
//  Created by 신지원 on 7/29/24.
//

import Foundation

struct BlockUserResponse: Decodable {
    var blocks: [BlockUserListDTO]
}

struct BlockUserListDTO: Decodable {
    var blockId: Int
    var userId: Int
    var nickname: String
    var avatarImage: String
}

struct BlockUserIdRequest: Encodable {
    var userId: Int
}
