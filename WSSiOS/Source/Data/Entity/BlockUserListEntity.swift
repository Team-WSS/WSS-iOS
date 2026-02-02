//
//  BlockUserEntity.swift
//  WSSiOS
//
//  Created by 신지원 on 3/6/25.
//

import Foundation

struct BlockUserListEntity {
    let blocks: [BlockUserEntity]
}

extension BlockUserListResponse {
    func toEntity() -> BlockUserListEntity {
        return BlockUserListEntity(blocks: self.blocks.map { $0.toEntity() })
    }
}

struct BlockUserEntity {
    var blockId: Int
    var userId: Int
    var nickname: String
    var avatarImage: String
}

extension BlockUserResponse {
    func toEntity() -> BlockUserEntity {
        let nicknameText = self.nickname.count > 8 ? self.nickname.prefix(8) + "..." : self.nickname
        return BlockUserEntity(blockId: self.blockId,
                                   userId: self.userId,
                                   nickname: nicknameText,
                                   avatarImage: self.avatarImage)
    }
}
