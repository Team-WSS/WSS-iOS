//
//  NovelService.swift
//  WSSiOS
//
//  Created by 최서연 on 1/14/24.
//

import Foundation

import RxSwift

protocol NovelService {
    func getSearchNovelData(searchWord: String) -> Single<SearchNovels>
}

final class DefaultNovelService: NSObject, Networking {
    private var urlSession = URLSession(configuration: URLSessionConfiguration.default,
                                        delegate: nil,
                                        delegateQueue: nil)
}

extension DefaultNovelService: NovelService {
    
    func getSearchNovelData(searchWord: String) -> Single<SearchNovels> {
        
        guard let encodedSearchWord = searchWord.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return Single.error(NSError(domain: "URL Encoding Error", code: 0, userInfo: nil))
        }
        
        print(encodedSearchWord)

        let searchListQueryItems: [URLQueryItem] = [
            URLQueryItem(name: "lastNovelId", value: String(describing: 999999)),
            URLQueryItem(name: "size", value: String(describing: 40)),
            URLQueryItem(name: "word", value: "BL")
        ]
        
        let request = try! makeHTTPRequest(method: .get,
                                           path: URLs.Novel.getSearchList,
                                           queryItems: searchListQueryItems,
                                           headers: APIConstants.testTokenHeader,
                                           body: nil)
        
        NetworkLogger.log(request: request)
        
        return urlSession.rx.data(request: request)
            .map { try self.decode(data: $0, to: SearchNovels.self) }
            .asSingle()
    }
}
