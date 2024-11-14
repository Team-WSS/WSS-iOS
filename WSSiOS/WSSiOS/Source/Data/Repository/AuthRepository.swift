//
//  AuthRepository.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 11/2/24.
//

import Foundation

import KakaoSDKAuth
import RxKakaoSDKAuth
import RxSwift

protocol AuthRepository {
    func loginWithApple(userIdentifier: String, email: String?) -> Observable<LoginResult>
    func loginWithKakao(_ kakaoAccessToken: OAuthToken) -> Single<LoginResult> 
}

struct DefaultAuthRepository: AuthRepository {
    
    private var authService: AuthService
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    func loginWithApple(userIdentifier: String, email: String?) -> Observable<LoginResult> {
        return authService.loginWithApple(userIdentifier: userIdentifier,
                                          email: email)
            .asObservable()
    }
    
    func loginWithKakao(_ kakaoAccessToken: OAuthToken) -> Single<LoginResult> {
        return authService.loginWithKakao(kakaoAccessToken.accessToken)
    }
}

