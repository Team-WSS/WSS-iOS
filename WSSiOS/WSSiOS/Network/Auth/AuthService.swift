//
//  AuthService.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 11/2/24.
//

import Foundation

import RxSwift

protocol AuthService {
    func loginWithApple(userIdentifier: String,
                        email: String?) -> Single<LoginResult>
    func loginWithKakao(_ kakaoAccessToken: String) -> Single<LoginResult>
    func reissueToken() -> Single<ReissueResult>
}

final class DefaultAuthService: NSObject, Networking, AuthService {
    func loginWithApple(userIdentifier: String, email: String?) -> RxSwift.Single<LoginResult> {
        guard let appleLoginBody = try? JSONEncoder().encode(AppleLoginBody(userIdentifier: userIdentifier, email: email)) else {
            return Single.error(NetworkServiceError.invalidRequestError)
        }
                
        do {
            let request = try makeHTTPRequest(method: .post,
                                              path: URLs.Auth.loginWithApple,
                                              headers: APIConstants.noTokenHeader,
                                              body: appleLoginBody)

            NetworkLogger.log(request: request)

            return basicURLSession.rx.data(request: request)
                .map { try self.decode(data: $0,
                                       to: LoginResult.self) }
                .asSingle()

        } catch {
            return Single.error(error)
        }
    }
    
    func loginWithKakao(_ kakaoAccessToken: String) -> Single<LoginResult> {
        do {
            let request = try makeHTTPRequest(method: .post,
                                              path: URLs.Auth.loginWithKakao,
                                              headers: APIConstants.kakaoLoginHeader(kakaoAccessToken),
                                              body: nil)

            NetworkLogger.log(request: request)

            return basicURLSession.rx.data(request: request)
                .map { try self.decode(data: $0,
                                       to: LoginResult.self) }
                .asSingle()
            
        } catch {
            return Single.error(error)
        }
    }
    
    func reissueToken() -> Single<ReissueResult> {
        guard let refreshToken = UserDefaults.standard.string(forKey: StringLiterals.UserDefault.refreshToken) else {
            return Single.error(NetworkServiceError.authenticationError)
        }
        
        guard let reissueBody = try? JSONEncoder().encode(ReissueBody(refreshToken: refreshToken)) else {
            return Single.error(NetworkServiceError.invalidRequestError)
        }
                
        do {
            let request = try makeHTTPRequest(method: .post,
                                              path: URLs.Auth.reissue,
                                              headers: APIConstants.noTokenHeader,
                                              body: reissueBody)

            NetworkLogger.log(request: request)

            return basicURLSession.rx.data(request: request)
                .map { try self.decode(data: $0,
                                       to: ReissueResult.self) }
                .asSingle()

        } catch {
            return Single.error(error)
        }
    }
}
    

