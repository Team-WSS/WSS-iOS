//
//  AvatarResponse.swift
//  WSSiOS
//
//  Created by 최서연 on 1/14/24.
//

import Foundation

struct AvatarListResponse: Decodable {
    let avatars: [AvatarResponse]
}

struct AvatarResponse: Decodable {
    let avatarId: Int
    let avatarName: String
    let avatarLine: String
    let avatarImage: String
    let isRepresentative: Bool
}
