//
//  BlockUserEntity.swift
//  WSSiOS
//
//  Created by 신지원 on 3/6/25.
//

import Foundation

struct BlockUserEntity {
    let blocks: [BlockUserListEntity]
}

extension BlockUserResponse {
    func toEntity() -> BlockUserEntity {
        return BlockUserEntity(blocks: self.blocks.map { $0.toEntity() })
    }
}

struct BlockUserListEntity {
    var blockId: Int
    var userId: Int
    var nickname: String
    var avatarImage: String
}

extension BlockUserListDTO {
    func toEntity() -> BlockUserListEntity {
        let nicknameText = self.nickname.count > 8 ? self.nickname.prefix(8) + "..." : self.nickname
        return BlockUserListEntity(blockId: self.blockId,
                                   userId: self.userId,
                                   nickname: nicknameText,
                                   avatarImage: self.avatarImage)
    }
}
