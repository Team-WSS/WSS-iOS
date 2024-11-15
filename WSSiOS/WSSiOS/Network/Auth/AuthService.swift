//
//  AuthService.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 11/2/24.
//

import Foundation

import RxSwift

protocol AuthService {
    func loginWithApple(authorizationCode: String,
                        idToken: String) -> Single<LoginResult>
}

final class DefaultAuthService: NSObject, Networking, AuthService {
    private var urlSession: URLSession = URLSession(configuration: URLSessionConfiguration.default,
                                                    delegate: nil,
                                                    delegateQueue: nil)
    
    func loginWithApple(authorizationCode: String, idToken: String) -> RxSwift.Single<LoginResult> {
        guard let appleLoginBody = try? JSONEncoder().encode(AppleLoginBody(authorizationCode: authorizationCode, idToken: idToken)) else {
            return Single.error(NetworkServiceError.invalidRequestError)
        }
                
        do {
            let request = try makeHTTPRequest(method: .post,
                                              path: URLs.Auth.loginWithApple,
                                              headers: APIConstants.noTokenHeader,
                                              body: appleLoginBody)

            NetworkLogger.log(request: request)

            return urlSession.rx.data(request: request)
                .map { try self.decode(data: $0,
                                       to: LoginResult.self) }
                .asSingle()

        } catch {
            return Single.error(error)
        }
    }
}
    

