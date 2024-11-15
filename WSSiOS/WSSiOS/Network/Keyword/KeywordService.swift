//
//  KeywordService.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 9/27/24.
//

import Foundation

import RxSwift

protocol KeywordService {
    func searchKeyword(query: String?) -> Single<SearchKeywordResult>
}

final class DefaultKeywordService: NSObject, Networking, KeywordService {
    func searchKeyword(query: String? = nil) -> RxSwift.Single<SearchKeywordResult> {
        var searchKeywordQueryItems: [URLQueryItem] = []
        
        if let query {
            searchKeywordQueryItems.append(URLQueryItem(name: "query", value: query))
        }
        
        do {
            let request = try makeHTTPRequest(method: .get,
                                              path: URLs.Keyword.searchKeyword,
                                              queryItems: searchKeywordQueryItems,
                                              headers: APIConstants.accessTokenHeader,
                                              body: nil)

            NetworkLogger.log(request: request)

            return tokenCheckURLSession.rx.data(request: request)
                .map { try self.decode(data: $0,
                                       to: SearchKeywordResult.self) }
                .asSingle()

        } catch {
            return Single.error(error)
        }
    }
}
