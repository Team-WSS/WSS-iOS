//
//  NovelService.swift
//  WSSiOS
//
//  Created by 이윤학 on 1/16/24.
//

import Foundation

import RxSwift

protocol NovelService {
    func getNovelInfo(novelId: Int?) -> Single<NovelResult>
}

final class DefaultNovelService: NSObject, Networking {
    private var urlSession: URLSession = URLSession(configuration: URLSessionConfiguration.default,
                                                    delegate: nil,
                                                    delegateQueue: nil)
}

extension DefaultNovelService: NovelService {
    func getNovelInfo(novelId: Int?) -> Single<NovelResult> {
        let request = try! makeHTTPRequest(method: .get,
                                           path: URLs.Novel.getNovelInfo.replacingOccurrences(of: "{novelId}", with: String(novelId ?? 0)),
                                           headers: APIConstants.testTokenHeader,
                                           body: nil)
        
        NetworkLogger.log(request: request)
        
        return urlSession.rx.data(request: request)
            .map {NovelResult(
                newNovelResult: try? JSONDecoder().decode(NewNovelResult.self, from: $0),
                editNovelResult: try? JSONDecoder().decode(EditNovelResult.self, from: $0))
            }
            .asSingle()
    }
}
