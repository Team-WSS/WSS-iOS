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
    func loginWithApple(authorizationCode: String, idToken: String) -> Observable<LoginResult>
    func loginWithKakao(_ kakaoAccessToken: OAuthToken) -> Single<LoginResult>
    func postWithdrawId(reason: String, refreshToken: String) -> Single<Void>
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
    
    func loginWithKakao(_ kakaoAccessToken: OAuthToken) -> Single<LoginResult> {
        return authService.loginWithKakao(kakaoAccessToken.accessToken)
    }
    
    func postWithdrawId(reason: String, refreshToken: String) -> Single<Void> {
        return authService.postWithdrawId(reason: reason, refreshToken: refreshToken)
    }
}

