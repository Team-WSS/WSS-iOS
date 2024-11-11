//
//  OnboardingService.swift
//  WSSiOS
//
//  Created by YunhakLee on 10/6/24.
//

import Foundation

import RxSwift

protocol OnboardingService {
    func getNicknameisValid(_ nickname: String) -> Single<OnboardingResult>
    func postUserProfile(userInfoResult: UserInfoResult) -> Single<Void>
}

final class DefaultOnboardingService: NSObject, Networking {
    private var urlSession: URLSession = URLSession(configuration: URLSessionConfiguration.default,
                                                    delegate: nil,
                                                    delegateQueue: nil)
}

extension DefaultOnboardingService: OnboardingService {
    func getNicknameisValid(_ nickname: String) -> Single<OnboardingResult> {
        let nicknameisValidQueryItems: [URLQueryItem] = [
            URLQueryItem(name: "nickname", value: String(describing: nickname))
        ]
        
        do {
            let request = try self.makeHTTPRequest(
                method: .get,
                path: URLs.Onboarding.nicknameCheck,
                queryItems: nicknameisValidQueryItems,
                headers: APIConstants.accessTokenHeader,
                body: nil
            )
            
            NetworkLogger.log(request: request)
            
            return customUrlSession.rx.data(request: request)
                .map { try self.decode(data: $0,
                                       to: OnboardingResult.self) }
                .asSingle()
            
        } catch {
            return Single.error(error)
        }
    }
    
    func postUserProfile(userInfoResult: UserInfoResult) -> Single<Void> {
        guard let userInfo = try? JSONEncoder().encode(userInfoResult) else {
            return Single.error(NetworkServiceError.invalidRequestError)
        }
        do {
            let request = try self.makeHTTPRequest(
                method: .post,
                path: URLs.Onboarding.postProfile,
                headers: APIConstants.accessTokenHeader,
                body: userInfo
            )
            
            NetworkLogger.log(request: request)
            
            return customUrlSession.rx.data(request: request)
                .map { _ in }
                .asSingle()
        } catch {
            return Single.error(error)
        }
    }
}
