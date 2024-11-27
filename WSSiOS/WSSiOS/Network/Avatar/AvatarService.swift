//
//  AvatarService.swift
//  WSSiOS
//
//  Created by 최서연 on 1/14/24.
//

import Foundation

import RxSwift

protocol AvatarService {
    func getAvatarList() -> Single<AvatarResponse>
}

final class DefaultAvatarService: NSObject, AvatarService, Networking {
    func getAvatarList() -> Single<AvatarResponse> {
        do {
            let request = try makeHTTPRequest(method: .get,
                                              path: URLs.Avatar.getAvatar,
                                              headers: APIConstants.accessTokenHeader,
                                              body: nil)
            
            NetworkLogger.log(request: request)
            
            return tokenCheckURLSession.rx.data(request: request)
                .map { try self.decode(data: $0,
                                       to: AvatarResponse.self) }
                .asSingle()
        } catch {
            return Single.error(error)
        }
    }
}
