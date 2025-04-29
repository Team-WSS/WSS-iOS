//
//  AvatarService.swift
//  WSSiOS
//
//  Created by 최서연 on 1/14/24.
//

import Foundation

import RxSwift

protocol AvatarService {
    func getAvatarList() -> Single<AvatarListResponse>
}

final class DefaultAvatarService: NSObject, Networking {
}

extension DefaultAvatarService: AvatarService {
    func getAvatarList() -> Single<AvatarListResponse> {
        do {
            let request = try makeHTTPRequest(method: .get,
                                              path: URLs.Avatar.getAvatar,
                                              headers: APIConstants.accessTokenHeader,
                                              body: nil)
            
            NetworkLogger.log(request: request)
            
            return tokenCheckURLSession.rx.data(request: request)
                .map { try self.decode(data: $0,
                                       to: AvatarListResponse.self) }
                .asSingle()
        } catch {
            return Single.error(error)
        }
    }
}
