//
//  BlockUserResult.swift
//  WSSiOS
//
//  Created by 신지원 on 7/29/24.
//

import Foundation

struct BlockUserListResponse: Decodable {
    var blocks: [BlockUserResponse]
}

struct BlockUserResponse: Decodable {
    var blockId: Int
    var userId: Int
    var nickname: String
    var avatarImage: String
}

struct BlockUserRequest: Encodable {
    var userId: Int
}
