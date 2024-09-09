//
//  BlockUserResult.swift
//  WSSiOS
//
//  Created by 신지원 on 7/29/24.
//

import Foundation

struct BlockUserResult: Codable {
    var blocks: [BlockList]
}

struct BlockList: Codable {
    var blockId: Int
    var userId: Int
    var nickname: String
    var avatarImage: String
}
