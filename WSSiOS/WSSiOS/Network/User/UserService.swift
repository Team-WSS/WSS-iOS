//
//  UserService.swift
//  WSSiOS
//
//  Created by 최서연 on 1/14/24.
//

import Foundation

import RxSwift

protocol UserService {
    func getUserCharacterData() -> Single<UserCharacter>
}

final class DefaultUserService: NSObject, Networking {
    
    private var urlSession = URLSession(configuration: URLSessionConfiguration.default,
                                        delegate: nil,
                                        delegateQueue: nil)
}

extension DefaultUserService: UserService {
    func getUserCharacterData() -> Single<UserCharacter> {
        let request = try! makeHTTPRequest(method: .get,
                                           path: URLs.Memo.getMemoList,
                                           headers: APIConstants.testTokenHeader,
                                           body: nil)
        
        NetworkLogger.log(request: request)
        
        return urlSession.rx.data(request: request)
            .map { try self.decode(data: $0, to: UserCharacter.self) }
            .asSingle()
    }
}
