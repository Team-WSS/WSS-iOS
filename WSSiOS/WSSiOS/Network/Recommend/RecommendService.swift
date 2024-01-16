//
//  RecommendService.swift
//  WSSiOS
//
//  Created by 최서연 on 1/14/24.
//

import Foundation

import RxSwift

protocol RecommendService {
    func getSosopickData() -> Single<SosopickNovels>
}

final class DefaultRecommendService: NSObject, Networking {
    
    private var urlSession = URLSession(configuration: URLSessionConfiguration.default,
                                        delegate: nil,
                                        delegateQueue: nil)
}

extension DefaultRecommendService: RecommendService {
    func getSosopickData() -> Single<SosopickNovels> {
        let request = try! makeHTTPRequest(method: .get,
                                           path: URLs.Recommend.getRecommendList,
                                           headers: APIConstants.testTokenHeader,
                                           body: nil)
        
        NetworkLogger.log(request: request)
        
        return urlSession.rx.data(request: request)
            .map { try self.decode(data: $0, to: SosopickNovels.self) }
            .asSingle()
    }
}
