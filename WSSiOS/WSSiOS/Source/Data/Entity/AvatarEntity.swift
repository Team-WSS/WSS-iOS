//
//  AvatarEntity.swift
//  WSSiOS
//
//  Created by 신지원 on 3/19/25.
//

struct AvatarListEntity {
    let avatars: [AvatarEntity]
}

extension AvatarListResponse {
    func toEntity() -> AvatarListEntity {
        return AvatarListEntity(avatars: self.avatars.map { $0.toEntity() })
    }
}

struct AvatarEntity {
    let avatarId: Int
    let avatarName: String
    let avatarLine: String
    let avatarImage: String
    let isRepresentative: Bool
}

extension AvatarResponse {
    func toEntity() -> AvatarEntity {
        return AvatarEntity(avatarId: self.avatarId,
                            avatarName: self.avatarName,
                            avatarLine: self.avatarLine,
                            avatarImage: self.avatarImage,
                            isRepresentative: self.isRepresentative)
    }
}
