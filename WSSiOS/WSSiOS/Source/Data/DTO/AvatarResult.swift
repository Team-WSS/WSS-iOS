//
//  AvatarDTO.swift
//  WSSiOS
//
//  Created by 최서연 on 1/14/24.
//

import Foundation

struct AvatarResponse: Codable {
    let avatars: [Avatar]
}

struct Avatar: Codable {
    let avatarId: Int
    let avatarName: String
    let avatarLine: String
    let avatarImage: String
    let isRepresentative: Bool
}
