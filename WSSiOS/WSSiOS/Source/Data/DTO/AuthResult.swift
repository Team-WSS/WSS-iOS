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

struct LoginResponse: Decodable {
    let Authorization: String
    let refreshToken: String
    let isRegister: Bool
}

struct ReissueRequest: Encodable {
    let refreshToken: String
}

struct ReissueResponse: Decodable {
    let Authorization: String
    let refreshToken: String
}

struct WithdrawRequest: Codable {
    let reason: String
    let refreshToken: String
}

struct LogoutRequest: Encodable {
    let refreshToken: String
    let deviceIdentifier: String
}
