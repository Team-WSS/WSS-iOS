//
//  OnboardingResult.swift
//  WSSiOS
//
//  Created by YunhakLee on 10/6/24.
//

import Foundation

struct OnboardingResponse: Decodable {
    let isValid: Bool
}

struct UserInfoRequest: Encodable {
    let nickname: String
    let gender: String
    let birth: Int
    let genrePreferences: [String]
}
