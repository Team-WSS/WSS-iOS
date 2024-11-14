//
//  AvatarService.swift
//  WSSiOS
//
//  Created by 최서연 on 1/14/24.
//

import Foundation

import RxSwift

protocol AvatarService {
    func getAvatarData(avatarId: Int) -> Single<AvatarResult>
    func patchAvatar(avatarId: Int) -> Single<Void>
}

final class DefaultAvatarService: NSObject, Networking {
    private let avatarListQueryItems: [URLQueryItem] = [URLQueryItem(name: "avatarId", value: String(describing: 2))]
}

extension DefaultAvatarService: AvatarService {
    func getAvatarData(avatarId: Int) -> RxSwift.Single<AvatarResult> {
        do {
            let request = try makeHTTPRequest(method: .get,
                                              path: URLs.Avatar.getAvatarDetail.replacingOccurrences(of: "{avatarId}", with: String(avatarId)),
                                              headers: APIConstants.accessTokenHeader,
                                              body: nil)
            
            NetworkLogger.log(request: request)
            
            return tokenCheckURLSession.rx.data(request: request)
                .map { try self.decode(data: $0,
                                       to: AvatarResult.self) }
                .asSingle()
        } catch {
            return Single.error(error)
        }
    }
    
    func patchAvatar(avatarId: Int) -> RxSwift.Single<Void> {
        guard let avatarIdData = try? JSONEncoder().encode(AvatarChangeResult(avatarId: avatarId))
                
        else {
            return .error(NetworkServiceError.invalidRequestError)
        }
        
        do {
            let request = try makeHTTPRequest(method: .patch,
                                              path: URLs.Avatar.patchRepAvatar,
                                              queryItems: avatarListQueryItems,
                                              headers: APIConstants.accessTokenHeader,
                                              body: avatarIdData)
            
            NetworkLogger.log(request: request)
            
            return tokenCheckURLSession.rx.data(request: request)
                .map { _ in }
                .asSingle()
        } catch {
            return Single.error(error)
        }
    }
}


