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
            let request = try makeHTTPRequest(method: .get,
                                              path: URLs.Onboarding.nicknameCheck,
                                              queryItems: nicknameisValidQueryItems,
                                              headers: APIConstants.testTokenHeader,
                                              body: nil)
            
            NetworkLogger.log(request: request)
            
            return urlSession.rx.data(request: request)
                .map { try self.decode(data: $0,
                                       to: OnboardingResult.self) }
                .asSingle()
            
        } catch {
            return Single.error(error)
        }
    }
}
