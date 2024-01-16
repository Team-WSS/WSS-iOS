//
//  MemoService.swift
//  WSSiOS
//
//  Created by 최서연 on 1/14/24.
//

import Foundation

import RxSwift

protocol MemoService {
    func getRecordMemosData() -> Single<RecordMemos>
}

final class DefaultMemoService: NSObject, Networking {
    
    private var urlSession = URLSession(configuration: URLSessionConfiguration.default,
                                        delegate: nil,
                                        delegateQueue: nil)
}

extension DefaultMemoService: MemoService {
    func getRecordMemosData() -> Single<RecordMemos> {
        let recordListQueryItems: [URLQueryItem] = [
            URLQueryItem(name: "lastMemoId", value: String(describing: 1000)),
            URLQueryItem(name: "size", value: String(describing: 5)),
            URLQueryItem(name: "sortType", value: "NEWEST")]
        
        let request = try! makeHTTPRequest(method: .get,
                                           path: URLs.Memo.getMemoList,
                                           queryItems: recordListQueryItems,
                                           headers: APIConstants.testTokenHeader,
                                           body: nil)
        
        NetworkLogger.log(request: request)
        
        return urlSession.rx.data(request: request)
            .map { try self.decode(data: $0, to: RecordMemos.self) }
            .asSingle()
    }
}
