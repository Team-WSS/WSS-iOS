//
//  UserDTO.swift
//  WSSiOS
//
//  Created by 신지원 on 1/15/24.
//

import Foundation

struct MyProfileResult: Codable {
    let nickname, intro, avatarImage: String
    let genrePreferences: [String]
}

struct OtherProfileResult: Codable {
    let nickname, intro, avatarImage: String
    let genrePreferences: [String]
    let isProfilePublic: Bool
}

struct UserProfileVisibility: Codable {
    let isProfilePublic: Bool
}
