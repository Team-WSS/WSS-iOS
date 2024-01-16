//
//  AvatarService.swift
//  WSSiOS
//
//  Created by 최서연 on 1/14/24.
//

import Foundation

import RxSwift

protocol AvatarService {
    func getAvatarData() -> Single<AvatarResult>
}

final class DefaultAvatarService: NSObject, Networking {
    private let avatarListQueryItems: [URLQueryItem] = [URLQueryItem(name: "avatarId", value: String(describing: 10))]
    private var urlSession: URLSession = URLSession(configuration: URLSessionConfiguration.default,
                                                    delegate: nil,
                                                    delegateQueue: nil)
}

extension DefaultAvatarService: AvatarService {
    func getAvatarData() -> RxSwift.Single<AvatarResult> {
        let request = try! makeHTTPRequest(method: .get,
                                           path: URLs.Avatar.getAvatarDetail,
                                           queryItems: avatarListQueryItems,
                                           headers: APIConstants.testTokenHeader,
                                           body: nil)
        
        NetworkLogger.log(request: request)
        
        return urlSession.rx.data(request: request)
            .map { try self.decode(data: $0,
                                   to: AvatarResult.self) }
            .asSingle()
    }
}


