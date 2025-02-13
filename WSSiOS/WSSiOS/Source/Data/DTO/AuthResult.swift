//
//  AuthResult.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 11/2/24.
//

import Foundation

struct AppleLoginBody: Codable {
    let authorizationCode: String
    let idToken: String
}

struct LoginResult: Codable {
    let Authorization: String
    let refreshToken: String
    let isRegister: Bool
}

struct ReissueBody: Codable {
    let refreshToken: String
}

struct ReissueResult: Codable {
    let Authorization: String
    let refreshToken: String
}

struct WithdrawRequest: Codable {
    let reason: String
    let refreshToken: String
}

struct LogoutRequest: Codable {
    let refreshToken: String
    let deviceIdentifier: String
}
