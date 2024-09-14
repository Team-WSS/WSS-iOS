//
//  MemoService.swift
//  WSSiOS
//
//  Created by 최서연 on 1/14/24.
//

import Foundation

import RxSwift

protocol MemoService {
    func getRecordMemos(lastId: Int, sort: String) -> Single<RecordMemos>
    func postMemo(userNovelId: Int, memoContent: String) -> Single<IsAvatarUnlocked>
    func postFeed(relevantCategories: [String], feedContent: String, novelId: Int?, isSpoiler: Bool) -> Single<Void>
    func putFeed(feedId: Int, relevantCategories: [String], feedContent: String, novelId: Int?, isSpoiler: Bool) -> Single<Void>
    func getMemoDetail(memoId: Int) -> Single<MemoDetail>
    func deleteMemo(memoId: Int) -> Single<Void>
    func patchMemo(memoId: Int, memoContent: String) -> Single<Void>
}

final class DefaultMemoService: NSObject, Networking {
    private var recordListSize = 1000
    private var urlSession = URLSession(configuration: URLSessionConfiguration.default,
                                        delegate: nil,
                                        delegateQueue: nil)
}

extension DefaultMemoService: MemoService {
    func getRecordMemos(lastId: Int, sort: String) -> Single<RecordMemos> {
        do {
            let recordListQueryItems: [URLQueryItem] = [
                URLQueryItem(name: "lastMemoId", value: String(describing: lastId)),
                URLQueryItem(name: "size", value: String(describing: recordListSize)),
                URLQueryItem(name: "sortType", value: sort)]
            
            let request = try makeHTTPRequest(method: .get,
                                               path: URLs.Memo.getMemoList,
                                               queryItems: recordListQueryItems,
                                               headers: APIConstants.testTokenHeader,
                                               body: nil)
            
            NetworkLogger.log(request: request)
            
            return urlSession.rx.data(request: request)
                .map { try self.decode(data: $0, to: RecordMemos.self) }
                .asSingle()
        } catch {
            return Single.error(error)
        }
    }
    
    func postMemo(userNovelId: Int, memoContent: String) -> Single<IsAvatarUnlocked> {
        guard let memoContentData = try? JSONEncoder().encode(MemoContent(memoContent: memoContent)) else {
            return Single.error(NetworkServiceError.invalidRequestError)
        }
        
        do {
            let request = try makeHTTPRequest(method: .post,
                                              path: URLs.Memo.postMemo(userNovelId: userNovelId),
                                              headers: APIConstants.testTokenHeader,
                                              body: memoContentData)
            
            NetworkLogger.log(request: request)
            
            return urlSession.rx.data(request: request)
                .map { try self.decode(data: $0, to: IsAvatarUnlocked.self) }
                .asSingle()
        } catch {
            return Single.error(error)
        }
    }
    
    func postFeed(relevantCategories: [String], feedContent: String, novelId: Int?, isSpoiler: Bool) -> Single<Void> {
        guard let feedContentData = try? JSONEncoder().encode(FeedContent(relevantCategories: relevantCategories, feedContent: feedContent, novelId: novelId, isSpoiler: isSpoiler)) else {
            return Single.error(NetworkServiceError.invalidRequestError)
        }
        
        do {
            let request = try makeHTTPRequest(method: .post,
                                              path: URLs.Memo.postFeed,
                                              headers: APIConstants.testTokenHeader,
                                              body: feedContentData)
            
            NetworkLogger.log(request: request)
            
            return urlSession.rx.data(request: request)
                .map { _ in }
                .asSingle()
        } catch {
            return Single.error(error)
        }
    }
    
    func putFeed(feedId: Int, relevantCategories: [String], feedContent: String, novelId: Int?, isSpoiler: Bool) -> Single<Void> {
        guard let feedContentData = try? JSONEncoder().encode(FeedContent(relevantCategories: relevantCategories, feedContent: feedContent, novelId: novelId, isSpoiler: isSpoiler)) else {
            return Single.error(NetworkServiceError.invalidRequestError)
        }
        
        do {
            let request = try makeHTTPRequest(method: .put,
                                              path: URLs.Memo.putFeed(feedId: feedId),
                                              headers: APIConstants.testTokenHeader,
                                              body: feedContentData)
            
            NetworkLogger.log(request: request)
            
            return urlSession.rx.data(request: request)
                .map { _ in }
                .asSingle()
        } catch {
            return Single.error(error)
        }
    }
    
    func getMemoDetail(memoId: Int) -> Single<MemoDetail> {
        do {
            let request = try makeHTTPRequest(method: .get,
                                              path: URLs.Memo.getMemo(memoId: memoId),
                                              headers: APIConstants.testTokenHeader,
                                              body: nil)
            
            NetworkLogger.log(request: request)
            
            return urlSession.rx.data(request: request)
                .map { try self.decode(data: $0, to: MemoDetail.self) }
                .asSingle()
        } catch {
            return Single.error(error)
        }
    }
    
    func deleteMemo(memoId: Int) -> Single<Void> {
        do {
            let request = try makeHTTPRequest(method: .delete,
                                               path: URLs.Memo.deleteMemo(memoId: memoId),
                                               headers: APIConstants.testTokenHeader,
                                               body: nil)
            
            NetworkLogger.log(request: request)
            
            return urlSession.rx.data(request: request)
                .map { _ in }
                .asSingle()
        } catch {
            return Single.error(error)
        }
    }
    
    func patchMemo(memoId: Int, memoContent: String) -> Single<Void> {
        guard let memoContentData = try? JSONEncoder().encode(MemoContent(memoContent: memoContent)) else {
            return Single.error(NetworkServiceError.invalidRequestError)
        }
        
        do {
            let request = try makeHTTPRequest(method: .patch,
                                              path: URLs.Memo.patchMemo(memoId: memoId),
                                              headers: APIConstants.testTokenHeader,
                                              body: memoContentData)
            
            NetworkLogger.log(request: request)
            
            return urlSession.rx.data(request: request)
                .map { _ in }
                .asSingle()
        } catch {
            return Single.error(error)
        }
    }
}
