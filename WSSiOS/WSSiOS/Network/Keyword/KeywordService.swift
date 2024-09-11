//
//  KeywordService.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 9/10/24.
//

import Foundation

import RxSwift

protocol KeywordService {
    func getSearchKeywords(query: String) -> Single<DetailSearchCategories>
}

final class DefaultKeywordService: NSObject, Networking {
    private var urlSession: URLSession = URLSession(configuration: URLSessionConfiguration.default,
                                                    delegate: nil,
                                                    delegateQueue: nil)
}

extension DefaultKeywordService: KeywordService {
    func getSearchKeywords(query: String) -> Single<DetailSearchCategories> {
        do {
            let request = try makeHTTPRequest(method: .get,
                                              path: URLs.Keyword.getKeywords,
                                              headers: APIConstants.testTokenHeader,
                                              body: nil)
            
            NetworkLogger.log(request: request)
            
            return urlSession.rx.data(request: request)
                .map {try self.decode(data: $0,
                                      to: DetailSearchCategories.self) }
                .asSingle()
        } catch {
            return Single.error(error)
        }
    }
}
