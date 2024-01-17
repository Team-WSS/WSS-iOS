//
//  AvatarDTO.swift
//  WSSiOS
//
//  Created by 최서연 on 1/14/24.
//

import Foundation

struct AvatarResult: Codable {
    let avatarTag,
        avatarGenreBadgeImg,
        avatarMent,
        avatarCondition: String
}

struct AvatarChangeResult: Codable {
    let avatarId: Int
}
