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
