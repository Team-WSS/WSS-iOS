//
//  UserService.swift
//  WSSiOS
//
//  Created by 최서연 on 1/14/24.
//

import Foundation

import RxSwift

protocol UserService {
    func getUserData() -> Single<UserResult>
    func patchUserName(userNickName: String) -> Single<Void>
    func getUserCharacterData() -> Single<UserCharacter>
    func getUserNovelStatus() -> Single<UserNovelStatus>
    func getUserInfo() -> Single<UserInfo>
    func putUserInfo(gender: String, birth: Int) -> Single<Void>
}

final class DefaultUserService: NSObject, Networking {
    private let userNickNameQueryItems: [URLQueryItem] = [URLQueryItem(name: "userNickname",
                                                                       value: String(describing: 10))]
    
    private func makeUserInfoQueryItems(gender: String,
                                        birth: Int) -> [URLQueryItem] {
        return [
            URLQueryItem(name: "gender", value: gender),
            URLQueryItem(name: "birth", value: String(describing: birth))
        ]
    }
    
    private var urlSession: URLSession = URLSession(configuration: URLSessionConfiguration.default,
                                                    delegate: nil,
                                                    delegateQueue: nil)
}

extension DefaultUserService: UserService {
    func getUserData() -> RxSwift.Single<UserResult> {
        do {
            let request = try makeHTTPRequest(method: .get,
                                              path: URLs.User.afterDelete,
                                              headers: APIConstants.testTokenHeader,
                                              body: nil)
            
            
            NetworkLogger.log(request: request)
            
            return urlSession.rx.data(request: request)
                .map { try self.decode(data: $0,
                                       to: UserResult.self) }
                .asSingle()
        } catch {
            return Single.error(error)
        }
    }
    
    func patchUserName(userNickName: String) -> RxSwift.Single<Void> {
        guard let userNickNameData = try? JSONEncoder().encode(UserNickNameResult(userNickname: userNickName)) 
                
        else {
            return .error(NetworkServiceError.invalidRequestError)
        }
        
        do {
            let request = try makeHTTPRequest(method: .patch,
                                              path: URLs.User.patchUserNickname,
                                              queryItems: userNickNameQueryItems,
                                              headers: APIConstants.testTokenHeader,
                                              body: userNickNameData)
            
            NetworkLogger.log(request: request)
            
            return urlSession.rx.data(request: request)
                .map { _ in }
                .asSingle()
        } catch {
            return Single.error(error)
        }
    }
    
    func getUserCharacterData() -> Single<UserCharacter> {
        do {
            let request = try makeHTTPRequest(method: .get,
                                              path: URLs.Avatar.getRepAvatar,
                                              headers: APIConstants.testTokenHeader,
                                              body: nil)
            
            NetworkLogger.log(request: request)
            
            return urlSession.rx.data(request: request)
                .map { try self.decode(data: $0,
                                       to: UserCharacter.self) }
                .asSingle()
        } catch {
            return Single.error(error)
        }
    }
    
    func getUserNovelStatus() -> RxSwift.Single<UserNovelStatus> {
        do {
            let request = try makeHTTPRequest(method: .get,
                                              path: URLs.User.getUserNovelStatus,
                                              headers: APIConstants.testTokenHeader,
                                              body: nil)
            
            NetworkLogger.log(request: request)
            
            return urlSession.rx.data(request: request)
                .map { try self.decode(data: $0,
                                       to: UserNovelStatus.self) }
                .asSingle()
        } catch {
            return Single.error(error)
        }
    }
    
    func getUserInfo() -> RxSwift.Single<UserInfo> {
        do {
            let request = try makeHTTPRequest(method: .get,
                                              path: URLs.User.userInfo,
                                              headers: APIConstants.testTokenHeader,
                                              body: nil)
            
            NetworkLogger.log(request: request)
            
            return urlSession.rx.data(request: request)
                .map { try self.decode(data: $0,
                                       to: UserInfo.self) }
                .asSingle()
            
        } catch {
            return Single.error(error)
        }
    }
    
    func putUserInfo(gender: String, birth: Int) -> RxSwift.Single<Void> {
        guard let userInfoData = try? JSONEncoder().encode(ChangeUserInfo(gender: gender,
                                                                          birth: birth)) 
                
        else {
            return .error(NetworkServiceError.invalidRequestError)
        }
        
        do {
            let request = try makeHTTPRequest(method: .put,
                                              path: URLs.User.userInfo,
                                              queryItems: makeUserInfoQueryItems(gender: gender, birth: birth),
                                              headers: APIConstants.testTokenHeader,
                                              body: userInfoData)
            
            NetworkLogger.log(request: request)
            
            return urlSession.rx.data(request: request)
                .map { _ in }
                .asSingle()
        } catch {
            return Single.error(error)
        }
    }
}


