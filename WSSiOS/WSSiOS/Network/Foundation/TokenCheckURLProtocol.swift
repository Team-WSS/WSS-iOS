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
    
    // 토큰 갱신 API 호출 스트림을 공유하여 토큰 갱신이 진행되는 동안에는
    // 구독할 때마다 새로 스트림이 생기는 것을 막아 토큰 리이슈 API 중복 호출 방지
    private static var tokenRefreshSubject = BehaviorSubject<Void>(value: ())
    private static var tokenRefreshObservable: Observable<ReissueResult> = {
        return tokenRefreshSubject
            .asObservable()
            .flatMapLatest { _ in
                return DefaultAuthService().reissueToken().asObservable()
            }
            .do(onNext: { _ in
                print("====== Success To Get New Token ======")
            }, onError: { _ in
                print("====== Fail To Get New Token ====== ")
            }, onSubscribe: {
                print("====== Try To Get New Token ======")
            })
            .share()
        
    }()
    
    // 해당 요청을 이 프로토콜이 처리할지 여부를 결정합니다.
    // Handled에 값이 없는 경우에만(API를 처음 호출할 때만) 이 프로토콜이 처리한다.
    // 한번 이 프로토콜에서 처리하고 나면, startLoading() 과정에서
    // Handled 값은 true로 들어가므로 더이상 이 프로토콜이 처리하지 않음.
    override class func canInit(with request: URLRequest) -> Bool {
        return URLProtocol.property(forKey: "Handled", in: request) == nil
    }
    
    // 요청을 수정할 필요가 있을 때 호출됩니다.
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    // 실제 네트워크 요청 처리
    override func startLoading() {
        // 원래 요청으로 데이터 테스크 시작
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 401, 404: // 401: 토큰 만료, 404: 유저 탈퇴 가능성 확인
                    self.handleUnauthorizedResponse()
                default: // 일반적인 응답 처리
                    self.handleTaskResult(data: data, response: response, error: error)
                }
            } else { // 일반적인 응답 처리
                self.handleTaskResult(data: data, response: response, error: error)
            }
        }
        task.resume()
    }
    
    private func handleUnauthorizedResponse() {
        TokenCheckURLProtocol.tokenRefreshObservable
            .subscribe(with: self, onNext: { owner, result in
                // 새로운 토큰 저장 후 갱신된 토큰으로 요청 재시도
                owner.updateTokens(result: result)
                owner.retryRequestWithNewToken()
            }, onError: { owner, error in
                // 실패 시 유저 정보를 삭제하고 로그인 VC로 이동
                owner.deleteTokenAndMoveToLoginViewController(error: error)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func handleTaskResult(data: Data?, response: URLResponse?, error: Error?) {
        if let error = error {
            self.client?.urlProtocol(self, didFailWithError: error)
        } else {
            if let data = data {
                client?.urlProtocol(self, didLoad: data)
            }
            if let response = response {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            
            client?.urlProtocolDidFinishLoading(self)
        }
    }
    
    private func retryRequestWithNewToken() {
        // 갱신된 토큰으로 새로운 요청 생성
        guard let mutableRequest = (self.request as NSURLRequest).mutableCopy() as? NSMutableURLRequest else {
            return
        }
        URLProtocol.setProperty(true, forKey: "Handled", in: mutableRequest)
        mutableRequest.setValue("Bearer " + APIConstants.accessToken, forHTTPHeaderField: APIConstants.auth)
        let newRequest = mutableRequest as URLRequest
        
        // 새로운 토큰으로 요청 재시도
        let retryTask = URLSession.shared.dataTask(with: newRequest) { data, response, error in
            self.handleTaskResult(data: data, response: response, error: error)
        }
        retryTask.resume()
    }
    
    private func deleteTokenAndMoveToLoginViewController(error: Error) {
        // 실패 시 토큰을 삭제하고 로그인 VC로 이동
        DispatchQueue.main.async {
            self.deleteUserInfo()
            self.moveToLoginViewController()
        }
        self.client?.urlProtocol(self, didFailWithError: error)
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
    
    private func deleteUserInfo() {
        UserDefaults.standard.removeObject(forKey: StringLiterals.UserDefault.userId)
        UserDefaults.standard.removeObject(forKey: StringLiterals.UserDefault.userNickname)
        UserDefaults.standard.removeObject(forKey: StringLiterals.UserDefault.userGender)
        UserDefaults.standard.removeObject(forKey: StringLiterals.UserDefault.accessToken)
        UserDefaults.standard.removeObject(forKey: StringLiterals.UserDefault.refreshToken)
    }
    
    private func moveToLoginViewController() {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
            return
        }
        sceneDelegate.setRootToLoginViewController()
    }
}
