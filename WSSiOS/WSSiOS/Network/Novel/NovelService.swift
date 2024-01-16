//
//  NovelService.swift
//  WSSiOS
//
//  Created by 최서연 on 1/14/24.
//

import Foundation

import RxSwift

protocol NovelService {
    func getSearchNovelData() -> Single<SearchNovels>
}

final class DefaultNovelService: NSObject, Networking {
    private var urlSession = URLSession(configuration: URLSessionConfiguration.default,
                                        delegate: nil,
                                        delegateQueue: nil)
}

extension DefaultNovelService: NovelService {
    
    func getSearchNovelData() -> Single<SearchNovels> {
        let searchListQueryItems: [URLQueryItem] = [
            URLQueryItem(name: "lastMemoId", value: String(describing: 999999)),
            URLQueryItem(name: "size", value: String(describing: 40)),
            //MARK: - 사용자에게 받은 문자열을 쿼리로 넣어줘야함.
            URLQueryItem(name: "word", value: "")]
        
        let request = try! makeHTTPRequest(method: .get,
                                           path: URLs.Memo.getMemoList,
                                           queryItems: searchListQueryItems,
                                           headers: APIConstants.testTokenHeader,
                                           body: nil)
        
        NetworkLogger.log(request: request)
        
        return urlSession.rx.data(request: request)
            .map { try self.decode(data: $0, to: SearchNovels.self) }
            .asSingle()
    }
}
