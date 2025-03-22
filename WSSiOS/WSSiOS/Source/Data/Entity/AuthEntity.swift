//
//  AuthEntity.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 3/23/25.
//

import Foundation

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
