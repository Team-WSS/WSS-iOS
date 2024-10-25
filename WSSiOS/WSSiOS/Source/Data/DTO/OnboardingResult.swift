//
//  OnboardingResult.swift
//  WSSiOS
//
//  Created by YunhakLee on 10/6/24.
//

import Foundation

struct OnboardingResult: Codable {
    let isValid: Bool
}

struct UserInfoResult: Codable {
    let nickname: String
    let gender: String
    let birth: Int
    let genrePreferences: [String]
}
