//
//  ProfileEntity.swift
//  WSSiOS
//
//  Created by 신지원 on 3/19/25.
//

import Foundation

struct MyProfileEntity {
    let nickname, intro, avatarImage: String
    let genrePreferences: [String]
}

extension MyProfileResponse {
    func toEntity() -> MyProfileEntity {
        return MyProfileEntity(nickname: self.nickname,
                               intro: self.intro,
                               avatarImage: self.avatarImage,
                               genrePreferences: self.genrePreferences)
    }
}

struct OtherProfileEntity {
    let nickname, intro, avatarImage: String
    let genrePreferences: [String]
    let isProfilePublic: Bool
}

extension OtherProfileResponse {
    func toEntity() -> OtherProfileEntity {
        return OtherProfileEntity(nickname: self.nickname,
                                  intro: self.intro,
                                  avatarImage: self.avatarImage,
                                  genrePreferences: self.genrePreferences,
                                  isProfilePublic: self.isProfilePublic)
    }
}

struct ProfileFeedData {
    let nickname: String
    let avatarImage: String
}
