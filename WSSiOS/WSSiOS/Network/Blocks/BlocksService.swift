//
//  BlocksService.swift
//  WSSiOS
//
//  Created by 신지원 on 8/1/24.
//

import Foundation

import RxSwift

protocol BlocksService {
    func getBlocksList() -> Single<BlockUserResult>
    func deleteBlockUser(blockID: Int) -> Single<Void>
    func postBlockUser(blockID: Int) -> Single<Void>
}

final class DefaultBlocksService: NSObject, Networking {
    private func makeUserBlockQuery(userId: Int) -> [URLQueryItem] {
        return [URLQueryItem(name: "userId", value: String(describing: userId))]
    }
}

extension DefaultBlocksService: BlocksService {
    func getBlocksList() -> Single<BlockUserResult> {
        do {
            let request = try makeHTTPRequest(method: .get,
                                              path: URLs.MyPage.Block.blocks,
                                              headers: APIConstants.accessTokenHeader,
                                              body: nil)
            
            NetworkLogger.log(request: request)
            
            return tokenCheckURLSession.rx.data(request: request)
                .map { try self.decode(data: $0,
                                       to: BlockUserResult.self) }
                .asSingle()
        } catch {
            return Single.error(error)
        }
    }
    
    func deleteBlockUser(blockID: Int) -> Single<Void> {
        do {
            let request = try makeHTTPRequest(method: .delete,
                                              path: URLs.MyPage.Block.userBlocks(blockID: blockID),
                                              headers: APIConstants.accessTokenHeader,
                                              body: nil)
            
            
            NetworkLogger.log(request: request)
            
            return tokenCheckURLSession.rx.data(request: request)
                .map { _ in }
                .asSingle()
        } catch {
            return Single.error(error)
        }
    }
    
    func postBlockUser(blockID: Int) -> Single<Void> {
        guard let blockUser = try? JSONEncoder().encode(BlockUserId(userId: blockID)) else {
            return Single.error(NetworkServiceError.invalidRequestError)
        }
        do {
            let request = try makeHTTPRequest(method: .post,
                                              path: URLs.MyPage.Block.blocks,
                                              queryItems: makeUserBlockQuery(userId: blockID),
                                              headers: APIConstants.accessTokenHeader,
                                              body: blockUser)
            
            
            NetworkLogger.log(request: request)
            
            return tokenCheckURLSession.rx.data(request: request)
                .map { _ in }
                .asSingle()
        } catch {
            return Single.error(error)
        }
    }
}



