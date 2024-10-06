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
        
        return Single.create { single in
            do {
                let request = try self.makeHTTPRequest(
                    method: .get,
                    path: URLs.Onboarding.nicknameCheck,
                    queryItems: nicknameisValidQueryItems,
                    headers: APIConstants.testTokenHeader,
                    body: nil
                )
                
                NetworkLogger.log(request: request)
                
                let task = self.urlSession.dataTask(with: request) { data, response, error in
                    if let error = error {
                        single(.failure(error))
                        return
                    }
                    
                    guard let response = response as? HTTPURLResponse else {
                        single(.failure(NewNetworkServiceError.unknownError))
                        return
                    }
                    
                    guard let data = data else {
                        single(.failure(NewNetworkServiceError.emptyDataError))
                        return
                    }
                    
                    if 200..<300 ~= response.statusCode {
                        do {
                            let result = try self.decode(data: data, to: OnboardingResult.self)
                            single(.success(result))
                        } catch {
                            single(.failure(NewNetworkServiceError.responseDecodingError))
                        }
                    } else {
                        let result = try? self.decode(data: data, to: ServerErrorResponse.self)
                        single(.failure(NewNetworkServiceError(statusCode: response.statusCode, errorResponse: result)))
                    }
                   
                }
                task.resume()
                return Disposables.create {
                    task.cancel()
                }
            } catch {
                single(.failure(error))
            }
            
            return Disposables.create()
        }
    }
}
