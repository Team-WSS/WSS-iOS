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
    func postMemo(userNovelId: Int, memoContent: String) -> Single<IsAvatarUnlocked>
    func getMemoDetail(memoId: Int) -> Single<MemoDetail>
    func deleteMemo(memoId: Int) -> Single<Void>
    func patchMemo(memoId: Int, memoContent: String) -> Single<Void>
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
    
    func postMemo(userNovelId: Int, memoContent: String) -> Single<IsAvatarUnlocked> {
        guard let memoContentData = try? JSONEncoder().encode(MemoContent(memoContent: memoContent)) else {
            return Single.error(NetworkServiceError.invalidRequestError)
        }
        
        let request = try! makeHTTPRequest(method: .post,
                                           path: URLs.Memo.postMemo.replacingOccurrences(of: "{userNovelId}", with: String(userNovelId)),
                                           headers: APIConstants.testTokenHeader,
                                           body: memoContentData)
        
        NetworkLogger.log(request: request)
        
        return urlSession.rx.data(request: request)
            .map { try self.decode(data: $0, to: IsAvatarUnlocked.self) }
            .asSingle()
    }
    
    func getMemoDetail(memoId: Int) -> Single<MemoDetail> {
        let request = try! makeHTTPRequest(method: .get,
                                           path: URLs.Memo.getMemo.replacingOccurrences(of: "{memoId}", with: String(memoId)),
                                           headers: APIConstants.testTokenHeader,
                                           body: nil)
        
        NetworkLogger.log(request: request)
        
        return urlSession.rx.data(request: request)
            .map { try self.decode(data: $0, to: MemoDetail.self) }
            .asSingle()
    }
    
    func deleteMemo(memoId: Int) -> Single<Void> {
        let request = try! makeHTTPRequest(method: .delete,
                                           path: URLs.Memo.deleteMemo.replacingOccurrences(of: "{memoId}", with: String(memoId)),
                                           headers: APIConstants.testTokenHeader,
                                           body: nil)
        
        NetworkLogger.log(request: request)
        
        return urlSession.rx.data(request: request)
            .map { _ in }
            .asSingle()
    }
    
    func patchMemo(memoId: Int, memoContent: String) -> Single<Void> {
        guard let memoContentData = try? JSONEncoder().encode(MemoContent(memoContent: memoContent)) else {
            return Single.error(NetworkServiceError.invalidRequestError)
        }
        
        let request = try! makeHTTPRequest(method: .patch,
                                           path: URLs.Memo.patchMemo.replacingOccurrences(of: "{memoId}", with: String(memoId)),
                                           headers: APIConstants.testTokenHeader,
                                           body: memoContentData)
        
        NetworkLogger.log(request: request)
        
        return urlSession.rx.data(request: request)
            .map { _ in }
            .asSingle()
    }
}
