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

struct UserMeResult: Codable {
    let userId: Int
    let nickname: String
    let gender: String
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
    let email: String?
    let gender: String
    let birth: Int
}

struct ChangeUserInfo: Codable {
    let gender: String
    let birth: Int
}

struct UserNovelPreferences: Codable {
    let attractivePoints: [String]?
    let keywords: [Keyword]?
}

struct UserGenrePreferences: Codable {
    let genrePreferences: [GenrePreference]
}

struct GenrePreference: Codable {
    let genreName: String
    let genreImage: String
    let genreCount: Int
}

struct UserEditProfile: Codable {
    let avatarId: Int?
    let nickname: String?
    let intro: String?
    let genrePreferences: [String]
}
