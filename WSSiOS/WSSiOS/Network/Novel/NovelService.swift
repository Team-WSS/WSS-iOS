//
//  NovelService.swift
//  WSSiOS
//
//  Created by 이윤학 on 1/16/24.
//

import Foundation

import RxSwift

protocol NovelService {
    func getSearchNovelData(searchWord: String) -> Single<SearchNovels>
    func getNovelInfo(novelId: Int) -> Single<NovelResult>
}

final class DefaultNovelService: NSObject, Networking {
    private var urlSession: URLSession = URLSession(configuration: URLSessionConfiguration.default,
                                                    delegate: nil,
                                                    delegateQueue: nil)
}

extension DefaultNovelService: NovelService {
    func getSearchNovelData(searchWord: String) -> Single<SearchNovels> {
        let lastNovelId = 9999
        let searchSize = 1000
        let searchListQueryItems: [URLQueryItem] = [
            URLQueryItem(name: "lastNovelId", value: String(describing: lastNovelId)),
            URLQueryItem(name: "size", value: String(describing: searchSize)),
            URLQueryItem(name: "word", value: searchWord)
        ]
        
        do {
            let request = try makeHTTPRequest(method: .get,
                                               path: URLs.Novel.getSearchList,
                                               queryItems: searchListQueryItems,
                                               headers: APIConstants.testTokenHeader,
                                               body: nil)
            
            NetworkLogger.log(request: request)
            
            return urlSession.rx.data(request: request)
                .map { try self.decode(data: $0, to: SearchNovels.self) }
                .asSingle()
        } catch {
            return Single.error(error)
        }
    }
    
    func getNovelInfo(novelId: Int) -> Single<NovelResult> {
        do {
            let request = try makeHTTPRequest(method: .get,
                                               path: URLs.Novel.getNovelInfo(novelId: novelId),
                                               headers: APIConstants.testTokenHeader,
                                               body: nil)
            
            NetworkLogger.log(request: request)
            
            return urlSession.rx.data(request: request)
                .map {NovelResult(
                    newNovelResult: try? JSONDecoder().decode(NewNovelResult.self, from: $0),
                    editNovelResult: try? JSONDecoder().decode(EditNovelResult.self, from: $0))
                }
                .asSingle()
        } catch {
            return Single.error(error)
        }
    }
}
