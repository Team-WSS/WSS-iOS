//
//  ProfileEntity.swift
//  WSSiOS
//
//  Created by 신지원 on 3/19/25.
//

import Foundation

struct MyProfileEntity {
    let nickname, intro: String
    let genrePreferences: [String]
    let avatarImageURL: URL?
}

extension MyProfileResponse {
    func toEntity() -> MyProfileEntity {
        let avatarImageURL = KingFisherRxHelper.makeImageURLString(path: self.avatarImage)
        return MyProfileEntity(nickname: self.nickname,
                               intro: self.intro,
                               genrePreferences: self.genrePreferences,
                               avatarImageURL: avatarImageURL)
    }
}

struct UserProfileEntity {
    let nickname, intro: String
    let genrePreferences: [String]
    let isProfilePublic: Bool
    let avatarImageURL: URL?
}

extension UserProfileResponse {
    func toEntity() -> UserProfileEntity {
        let avatarImageURL = KingFisherRxHelper.makeImageURLString(path: self.avatarImage)
        return UserProfileEntity(nickname: self.nickname,
                                  intro: self.intro,
                                  genrePreferences: self.genrePreferences,
                                  isProfilePublic: self.isProfilePublic,
                                  avatarImageURL: avatarImageURL)
    }
}

struct ProfileFeedData {
    let nickname: String
    let avatarImage: String
}
