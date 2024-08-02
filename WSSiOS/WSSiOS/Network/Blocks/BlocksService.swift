//
//  BlocksService.swift
//  WSSiOS
//
//  Created by 신지원 on 8/1/24.
//

import Foundation

import RxSwift

protocol BlocksService {
    func deleteBlockUser(blockID: Int) -> Single<Void>
}

final class DefaultBlocksService: NSObject, Networking {
    private var urlSession: URLSession = URLSession(configuration: URLSessionConfiguration.default,
                                                    delegate: nil,
                                                    delegateQueue: nil)
}

extension DefaultBlocksService: BlocksService {
    func deleteBlockUser(blockID: Int) -> RxSwift.Single<Void> {
        do {
            let request = try makeHTTPRequest(method: .delete,
                                              path: URLs.MyPage.Block.userBlocks.replacingOccurrences(of: "{blockId}", with: String(blockID)),
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



