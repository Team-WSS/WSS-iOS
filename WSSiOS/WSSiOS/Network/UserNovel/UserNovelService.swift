//
//  UserNovelService.swift
//  WSSiOS
//
//  Created by 최서연 on 1/14/24.
//

import Foundation

import RxSwift

protocol UserNovelService {
    func getUserNovel(userNovelId: Int) -> Single<UserNovelDetail>
    func deleteUserNovel(userNovelId: Int) -> Single<Void>
    func postUserNovelAPI(novelId: Int, userNovelRating: Float?, userNovelReadStatus: ReadStatus, userNovelReadStartDate: String?, userNovelReadEndDate: String?) -> Single<UserNovelId>
}

final class DefaultUserNovelService: NSObject, Networking {
    private var urlSession: URLSession = URLSession(configuration: URLSessionConfiguration.default,
                                                    delegate: nil,
                                                    delegateQueue: nil)
}

extension DefaultUserNovelService: UserNovelService {
    func getUserNovel(userNovelId: Int) -> Single<UserNovelDetail> {
        let request = try! makeHTTPRequest(method: .get,
                                           path: URLs.UserNovel.getUserNovel.replacingOccurrences(of: "{userNovelId}", with: String(userNovelId)),
                                           headers: APIConstants.testTokenHeader,
                                           body: nil)
        
        NetworkLogger.log(request: request)
        
        return urlSession.rx.data(request: request)
            .map { try self.decode(data: $0, to: UserNovelDetail.self) }
            .asSingle()
    }
    
    func deleteUserNovel(userNovelId: Int) -> Single<Void> {
        let request = try! makeHTTPRequest(method: .delete,
                                           path: URLs.UserNovel.deleteUserNovel.replacingOccurrences(of: "{userNovelId}", with: String(userNovelId)),
                                           headers: APIConstants.testTokenHeader,
                                           body: nil)
        
        NetworkLogger.log(request: request)
        
        return urlSession.rx.data(request: request)
            .map { _ in }
            .asSingle()
    }

    func postUserNovelAPI(novelId: Int, userNovelRating: Float?, userNovelReadStatus: ReadStatus, userNovelReadStartDate: String?, userNovelReadEndDate: String?) -> Single<UserNovelId> {
        guard let userNovelBasic = try? JSONEncoder()
            .encode(UserNovelBasicInfo(userNovelRating: userNovelRating,
                                   userNovelReadStatus: userNovelReadStatus.rawValue,
                                   userNovelReadStartDate: userNovelReadStartDate,
                                   userNovelReadEndDate: userNovelReadEndDate)
            ) else {
            return Single.error(NetworkServiceError.invalidRequestError)
        }
        let request = try! makeHTTPRequest(method: .post,
                                           path: URLs.UserNovel.postUserNovel.replacingOccurrences(of: "{novelId}", with: String(novelId)),
                                           headers: APIConstants.testTokenHeader,
                                           body: userNovelBasic)
        
        NetworkLogger.log(request: request)
        
        return urlSession.rx.data(request: request)
            .map { try self.decode(data: $0, to: UserNovelId.self) }
            .asSingle()
    }
}
