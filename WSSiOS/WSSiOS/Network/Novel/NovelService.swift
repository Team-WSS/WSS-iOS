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

        let searchListQueryItems: [URLQueryItem] = [
            URLQueryItem(name: "lastNovelId", value: String(describing: 999999)),
            URLQueryItem(name: "size", value: String(describing: 40)),
            //MARK: - value값이 한글일때의 디코딩 처리 필요
            URLQueryItem(name: "word", value: searchWord.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
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
