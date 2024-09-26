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
}

final class DefaultBlocksService: NSObject, Networking {
    private var urlSession: URLSession = URLSession(configuration: URLSessionConfiguration.default,
                                                    delegate: nil,
                                                    delegateQueue: nil)
}

extension DefaultBlocksService: BlocksService {
    func getBlocksList() -> RxSwift.Single<BlockUserResult> {
        do {
            let request = try makeHTTPRequest(method: .get,
                                              path: URLs.MyPage.Block.blocks,
                                              headers: APIConstants.testTokenHeader,
                                              body: nil)
            
            NetworkLogger.log(request: request)
            
            return urlSession.rx.data(request: request)
                .map { try self.decode(data: $0,
                                       to: BlockUserResult.self) }
                .asSingle()
        } catch {
            return Single.error(error)
        }
    }
    
    func deleteBlockUser(blockID: Int) -> RxSwift.Single<Void> {
        do {
            let request = try makeHTTPRequest(method: .delete,
                                              path: URLs.MyPage.Block.userBlocks(blockID: blockID),
                                              headers: APIConstants.testTokenHeader,
                                              body: nil)
            
            
            NetworkLogger.log(request: request)
            
            return urlSession.rx.data(request: request)
                .map { _ in }
                .asSingle()
        } catch {
            return Single.error(error)
        }
    }
}



