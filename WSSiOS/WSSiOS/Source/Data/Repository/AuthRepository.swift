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
    func loginWithApple(authorizationCode: String, idToken: String) -> Observable<LoginResponse>
    func loginWithKakao(_ kakaoAccessToken: OAuthToken) -> Single<LoginResponse>
    func postWithdrawId(reason: String, refreshToken: String) -> Single<Void>
    func postLogout(refreshToken: String, deviceIdentifier: String) -> Single<Void>
}

struct DefaultAuthRepository: AuthRepository {
    
    private var authService: AuthService
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    func loginWithApple(authorizationCode: String, idToken: String) -> Observable<LoginResponse> {
        return authService.loginWithApple(authorizationCode: authorizationCode, idToken: idToken)
            .asObservable()
    }
    
    func loginWithKakao(_ kakaoAccessToken: OAuthToken) -> Single<LoginResponse> {
        return authService.loginWithKakao(kakaoAccessToken.accessToken)
    }
    
    func postWithdrawId(reason: String, refreshToken: String) -> Single<Void> {
        return authService.postWithdrawId(reason: reason, refreshToken: refreshToken)
    }
    
    func postLogout(refreshToken: String, deviceIdentifier: String) -> Single<Void> {
        let logoutRequest = LogoutRequest(refreshToken: refreshToken, deviceIdentifier: deviceIdentifier)
        return authService.postLogout(logoutRequest: logoutRequest)
    }
}

