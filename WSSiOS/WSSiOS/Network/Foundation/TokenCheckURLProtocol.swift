//
//  TokenCheckURLProtocol.swift
//  WSSiOS
//
//  Created by YunhakLee on 11/10/24.
//

import RxSwift
import UIKit

class TokenCheckURLProtocol: URLProtocol {
    
    private let disposeBag = DisposeBag()
    
    // 해당 요청을 이 프로토콜이 처리할지 여부를 결정합니다.
    // Handled에 값이 없는 경우에만(API를 처음 호출할 때만) 이 프로토콜이 처리한다.
    // 한번 이 프로토콜에서 처리하고 나면, startLoading() 과정에서
    // Handled 값은 true로 들어가므로 더이상 이 프로토콜이 처리하지 않음.
    override class func canInit(with request: URLRequest) -> Bool {
        if URLProtocol.property(forKey: "Handled", in: request) != nil {
            return false
        } else {
            return true
        }
    }
    
    // 요청을 수정할 필요가 있을 때 호출됩니다.
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    // 실제 네트워크 요청 처리
    override func startLoading() {
        // 원래 요청으로 데이터 태스크 시작
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                // 상태 코드가 401인지 확인
                if httpResponse.statusCode == 401 {
                    print("====== Try To Get New Token ======")
                    // 401 응답 시 토큰 갱신 로직 처리
                    DefaultAuthService().reissueToken()
                        .subscribe(with: self, onSuccess: { owner, result in
                            print("====== Success To Get New Token ======")
                            // 새로운 토큰 저장
                            owner.updateTokens(result: result)
                            
                            // 갱신된 토큰으로 새로운 요청 생성
                            guard let mutableRequest = (owner.request as NSURLRequest).mutableCopy() as? NSMutableURLRequest else {
                                return
                            }
                            URLProtocol.setProperty(true, forKey: "Handled", in: mutableRequest)
                            mutableRequest.setValue("Bearer " + result.Authorization, forHTTPHeaderField: APIConstants.auth)
                            let newRequest = mutableRequest as URLRequest
                            
                            // 새로운 토큰으로 요청 재시도
                            let retryTask = URLSession.shared.dataTask(with: newRequest) { data, response, error in
                                if let data = data {
                                    owner.client?.urlProtocol(owner, didLoad: data)
                                }
                                if let response = response {
                                    owner.client?.urlProtocol(owner, didReceive: response, cacheStoragePolicy: .notAllowed)
                                }
                                owner.client?.urlProtocolDidFinishLoading(owner)
                            }
                            retryTask.resume()
                        }, onFailure: { owner, error in
                            print("====== Fail To Get New Token ====== ")
                            // 실패 시 토큰을 삭제하고 로그인 VC로 이동
                            DispatchQueue.main.async {
                                owner.deleteTokens()
                                owner.moveToLoginViewController()
                            }
                        })
                        .disposed(by: self.disposeBag)
                } else {
                    // 401이 아닌 경우 일반적인 응답 처리
                    if let data = data {
                        self.client?.urlProtocol(self, didLoad: data)
                    }
                    if let response = response {
                        self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                    }
                    self.client?.urlProtocolDidFinishLoading(self)
                }
            } else if let error = error {
                // 일반적인 에러 처리
                self.client?.urlProtocol(self, didFailWithError: error)
            }
        }
        task.resume()
    }
    
    // 네트워크 요청 중단 시 호출됩니다.
    override func stopLoading() {
        // 필요 시 작업 중단 처리
    }
}

extension TokenCheckURLProtocol {
    private func updateTokens(result: ReissueResult) {
        UserDefaults.standard.setValue(result.Authorization,
                                       forKey: StringLiterals.UserDefault.accessToken)
        UserDefaults.standard.setValue(result.refreshToken,
                                       forKey: StringLiterals.UserDefault.refreshToken)
    }
    
    private func deleteTokens() {
        UserDefaults.standard.setValue(nil,
                                       forKey: StringLiterals.UserDefault.accessToken)
        UserDefaults.standard.setValue(nil,
                                       forKey: StringLiterals.UserDefault.refreshToken)
    }
    
    private func moveToLoginViewController() {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
            return
        }
        sceneDelegate.setRootToLoginViewController()
    }
}
