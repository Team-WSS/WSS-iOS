//
//  NovelService.swift
//  WSSiOS
//
//  Created by 이윤학 on 1/16/24.
//

import Foundation

import RxSwift

protocol NovelService {
    func getNovelInfo(novelId: Int) -> Single<NovelResult>
}

final class DefaultNovelService: NSObject, Networking { }

extension DefaultNovelService: NovelService {
    func getNovelInfo(novelId: Int) -> Single<NovelResult> {
        do {
            let request = try makeHTTPRequest(method: .get,
                                               path: URLs.Novel.getNovelInfo(novelId: novelId),
                                               headers: APIConstants.accessTokenHeader,
                                               body: nil)
            
            NetworkLogger.log(request: request)
            
            return tokenCheckURLSession.rx.data(request: request)
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
