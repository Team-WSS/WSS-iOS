//
//  MyProfileResponse.swift
//  WSSiOS
//
//  Created by 신지원 on 1/15/24.
//

import Foundation

struct MyProfileResponse: Decodable {
    let nickname, intro, avatarImage: String
    let genrePreferences: [String]
}

struct UserProfileResponse: Decodable {
    let nickname, intro, avatarImage: String
    let genrePreferences: [String]
    let isProfilePublic: Bool
}

struct UserProfileVisibilityResponse: Decodable {
    let isProfilePublic: Bool
}

struct UserProfileVisibilityRequest: Encodable {
    let isProfilePublic: Bool
}
