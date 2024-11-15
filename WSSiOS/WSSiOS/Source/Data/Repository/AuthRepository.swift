//
//  AuthRepository.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 11/2/24.
//

import Foundation

import RxSwift

protocol AuthRepository {
    func loginWithApple(authorizationCode: String, idToken: String) -> Observable<LoginResult>
}

struct DefaultAuthRepository: AuthRepository {
    
    private var authService: AuthService
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    func loginWithApple(authorizationCode: String, idToken: String) -> Observable<LoginResult> {
        return authService.loginWithApple(authorizationCode: authorizationCode, idToken: idToken)
            .asObservable()
    }
}

