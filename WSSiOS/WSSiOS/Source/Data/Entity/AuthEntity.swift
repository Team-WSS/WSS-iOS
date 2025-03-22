//
//  AuthEntity.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 3/23/25.
//

import Foundation

struct AppleLoginEntity {
    let authorizationCode: Data
    let idToken: Data
}

extension AppleLoginEntity {
    func toDTO() -> AppleLoginRequest {
        let authorizationCode = String(data: authorizationCode, encoding: String.Encoding.utf8)!
        let idToken = String(data: idToken, encoding: String.Encoding.utf8)!
        return AppleLoginRequest(authorizationCode: authorizationCode,
                                 idToken: idToken)
    }
}

struct LoginEntity {
    let Authorization: String
    let refreshToken: String
    let isRegister: Bool
}

extension LoginResponse {
    func toEntity() -> LoginEntity {
        return LoginEntity(Authorization: self.Authorization,
                           refreshToken: self.refreshToken,
                           isRegister: self.isRegister)
    }
}
