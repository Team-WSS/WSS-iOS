//
//  OnboardingResult.swift
//  WSSiOS
//
//  Created by YunhakLee on 10/6/24.
//

import Foundation

struct OnboardingResponse: Codable {
    let isValid: Bool
}

struct UserInfoRequest: Codable {
    let nickname: String
    let gender: String
    let birth: Int
    let genrePreferences: [String]
}
