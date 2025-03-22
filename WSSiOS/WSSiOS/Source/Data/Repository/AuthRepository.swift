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
    func loginWithApple(authorizationCode: String, idToken: String) -> Observable<LoginEntity>
    func loginWithKakao(_ kakaoAccessToken: OAuthToken) -> Single<LoginEntity>
    func postWithdrawId(withdrawData: WithdrawRequest) -> Observable<Void>
    func postLogout(refreshToken: String, deviceIdentifier: String) -> Observable<Void>
}

struct DefaultAuthRepository: AuthRepository {
    
    private var authService: AuthService
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    func loginWithApple(authorizationCode: String, idToken: String) -> Observable<LoginEntity> {
        return authService.loginWithApple(authorizationCode: authorizationCode, idToken: idToken)
            .map { $0.toEntity() }
            .asObservable()
    }
    
    func loginWithKakao(_ kakaoAccessToken: OAuthToken) -> Single<LoginEntity> {
        return authService.loginWithKakao(kakaoAccessToken.accessToken)
            .map { $0.toEntity() }
    }
    
    func postWithdrawId(withdrawData: WithdrawRequest) -> Observable<Void> {
        return authService.postWithdrawId(withdrawData: withdrawData)
            .asObservable()
    }
    
    func postLogout(refreshToken: String, deviceIdentifier: String) -> Observable<Void> {
        let logoutRequest = LogoutRequest(refreshToken: refreshToken, deviceIdentifier: deviceIdentifier)
        return authService.postLogout(logoutRequest: logoutRequest)
            .asObservable()
    }
}

