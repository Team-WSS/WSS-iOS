//
//  UserInfoResult.swift
//  WSSiOS
//
//  Created by 신지원 on 9/20/24.
//

import Foundation

struct UserResult: Codable {
    let representativeAvatarGenreBadge,
        representativeAvatarTag,
        representativeAvatarLineContent,
        representativeAvatarImg,
        userNickname: String
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

struct UserInfo: Codable {
    let email = String
    let gender = String
    let birth = Int
}
