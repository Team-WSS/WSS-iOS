//
//  AvatarEntity.swift
//  WSSiOS
//
//  Created by 신지원 on 3/19/25.
//

import Foundation

struct AvatarListEntity {
    let avatars: [AvatarEntity]
}

extension AvatarListResponse {
    func toEntity() -> AvatarListEntity {
        return AvatarListEntity(avatars: self.avatarProfiles.map { $0.toEntity() })
    }
}

struct AvatarEntity {
    let avatarId: Int
    let avatarName: String
    let avatarLine: String
    let avatarImageURL: URL? // 클릭 시 보이는 전체 캐릭터 이미지
    let avatarProfileImageURL: URL? // 동그란 프로필 이미지
    let isRepresentative: Bool
}

extension AvatarResponse {
    func toEntity() -> AvatarEntity {
        let avatarImageURL = KingFisherRxHelper.makeBucketImageURL(path: self.avatarCharacterImage)
        let avatarProfileImageURL = KingFisherRxHelper.makeBucketImageURL(path: self.avatarProfileImage)
        
        return AvatarEntity(avatarId: self.avatarProfileId,
                            avatarName: self.avatarProfileName,
                            avatarLine: self.avatarProfileLine,
                            avatarImageURL: avatarImageURL,
                            avatarProfileImageURL: avatarProfileImageURL,
                            isRepresentative: self.isRepresentative)
    }
}
