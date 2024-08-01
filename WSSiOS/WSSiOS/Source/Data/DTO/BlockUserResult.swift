//
//  BlockUserResult.swift
//  WSSiOS
//
//  Created by 신지원 on 7/29/24.
//

import Foundation

struct BlockUserResult {
    var blocks: [blockList]
}

struct blockList {
    var blockId: Int
    var userId: Int
    var nickname: String
    var avatarImage: String
}
