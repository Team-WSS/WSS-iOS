//
//  SearchService.swift
//  WSSiOS
//
//  Created by Guryss on 9/7/24.
//

import Foundation

import RxSwift

protocol SearchService {
    func getSosopicks() -> Single<SosoPickNovels>
}

final class DefaultSearchService: NSObject, Networking {
    
    private var urlSession = URLSession(configuration: URLSessionConfiguration.default,
                                        delegate: nil,
                                        delegateQueue: nil)
}

extension DefaultSearchService: SearchService {
    func getSosopicks() -> Single<SosoPickNovels> {
        do {
            let request = try makeHTTPRequest(method: .get,
                                              path: URLs.Search.sosoPick,
                                              headers: APIConstants.testTokenHeader,
                                              body: nil)
            
            NetworkLogger.log(request: request)
            
            return urlSession.rx.data(request: request)
                .map { try self.decode(data: $0,
                                       to: SosoPickNovels.self) }
                .asSingle()
            
        } catch {
            return Single.error(error)
        }
    }
}
