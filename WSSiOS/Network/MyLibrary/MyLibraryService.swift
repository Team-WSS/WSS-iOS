//
//  MyLibraryService.swift
//  WSSiOS
//
//  Created by 이윤학 on 6/27/25.
//

import Foundation

import RxSwift

protocol MyLibraryService {
    func getNovelList(userId: Int, queryItem: MyLibraryNovelListQuery) -> Single<MyLibraryListResponse>
    func getLibraryKeywords(userId: Int) -> Single<LibraryKeywordListResponse>
}

final class DefaultMyLibraryService: NSObject, Networking {
    
}

extension DefaultMyLibraryService: MyLibraryService {
    func getNovelList(userId: Int,
                      queryItem: MyLibraryNovelListQuery) -> Single<MyLibraryListResponse> {
        do {
            let request = try makeHTTPRequest(
                method: .get,
                path: URLs.MyLibrary.getMyLibrarList(userId: userId),
                queryItems: queryItem.asQueryItems(),
                headers: APIConstants.accessTokenHeader,
                body: nil
            )
            
            NetworkLogger.log(request: request)
            
            return tokenCheckURLSession.rx.data(request: request)
                .map { try self.decode(data: $0,
                                       to: MyLibraryListResponse.self)}
                .asSingle()

        } catch {
            return Single.error(error)
        }
    }

    func getLibraryKeywords(userId: Int) -> Single<LibraryKeywordListResponse> {
        do {
            let request = try makeHTTPRequest(
                method: .get,
                path: URLs.MyLibrary.getLibraryKeywords(userId: userId),
                headers: APIConstants.accessTokenHeader,
                body: nil
            )

            NetworkLogger.log(request: request)

            return tokenCheckURLSession.rx.data(request: request)
                .map { try self.decode(data: $0,
                                       to: LibraryKeywordListResponse.self)}
                .asSingle()

        } catch {
            return Single.error(error)
        }
    }
}



