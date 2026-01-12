//
//  AvatarResponse.swift
//  WSSiOS
//
//  Created by 최서연 on 1/14/24.
//

import Foundation

struct AvatarListResponse: Decodable {
    let avatarProfiles: [AvatarResponse]
}

struct AvatarResponse: Decodable {
    let avatarProfileId: Int
    let avatarProfileName: String
    let avatarProfileLine: String
    let avatarProfileImage: String
    let avatarCharacterImage: String
    let isRepresentative: Bool
}
