//
//  AvatarDTO.swift
//  WSSiOS
//
//  Created by 최서연 on 1/14/24.
//

import Foundation

public struct AvatarResult: Decodable {
    let avatarTag,
        avatarGenreBadgeImg,
        avatarMent,
        avatarCondition: String
}
