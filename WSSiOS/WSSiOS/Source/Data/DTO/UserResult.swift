//
//  UserDTO.swift
//  WSSiOS
//
//  Created by 신지원 on 1/15/24.
//

import Foundation

struct UserResult: Codable {
    let representativeAvatarGenreBadge,
               representativeAvatarTag,
               representativeAvatarLineContent,
               representativeAvatarImg,
               userNickName: String
    let representativeAvatarId, 
               userNovelCount,
               memoCount: Int
    let userAvatars: [UserAvatar]
}

struct UserAvatar: Codable {
    let avatarId: Int
    let avatarImg: String
    let hasAvatar: Bool
}

struct UserNickNameResult: Codable {
    let userNickname: String
}
