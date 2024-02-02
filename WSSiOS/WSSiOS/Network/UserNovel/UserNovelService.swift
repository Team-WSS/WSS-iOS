//
//  UserNovelService.swift
//  WSSiOS
//
//  Created by 최서연 on 1/14/24.
//

import Foundation

import RxSwift

protocol UserNovelService {
    func getUserNovelList(readStatus: String,
                          lastUserNovelId: Int,
                          size: Int,
                          sortType: String) -> Single<UserNovelList>
    func getUserNovel(userNovelId: Int) -> Single<UserNovelDetail>
    func deleteUserNovel(userNovelId: Int) -> Single<Void>
    func postUserNovel(novelId: Int, userNovelRating: Float?, userNovelReadStatus: ReadStatus, userNovelReadStartDate: String?, userNovelReadEndDate: String?) -> Single<UserNovelId>
    func patchUserNovel(userNovelId: Int, userNovelRating: Float?, userNovelReadStatus: ReadStatus, userNovelReadStartDate: String?, userNovelReadEndDate: String?) -> Single<Void>
}

final class DefaultUserNovelService: NSObject, Networking {
    func makeNovelListQuery(readStatus: String, lastUserNovelId: Int, size: Int, sortType: String) -> [URLQueryItem] {
            return [
                URLQueryItem(name: "readStatus", value: readStatus),
                URLQueryItem(name: "lastUserNovelId", value: String(describing: lastUserNovelId)),
                URLQueryItem(name: "size", value: String(describing: size)),
                URLQueryItem(name: "sortType", value: sortType)
            ]
        }
    
    private var urlSession: URLSession = URLSession(configuration: URLSessionConfiguration.default,
                                                    delegate: nil,
                                                    delegateQueue: nil)
}

extension DefaultUserNovelService: UserNovelService {
    func getUserNovelList(readStatus: String, lastUserNovelId: Int, size: Int, sortType: String) -> RxSwift.Single<UserNovelList> {
        let request = try! makeHTTPRequest(method: .get,
                                           path: URLs.UserNovel.getUserNovelList,
                                           queryItems: makeNovelListQuery(readStatus: readStatus,
                                                                          lastUserNovelId: lastUserNovelId,
                                                                          size: size,
                                                                          sortType: sortType),
                                           headers: APIConstants.testTokenHeader,
                                           body: nil)
        
        NetworkLogger.log(request: request)
        
        return urlSession.rx.data(request: request)
            .map { try self.decode(data: $0,
                                   to: UserNovelList.self) }
            .asSingle()
    }
    
    func getUserNovel(userNovelId: Int) -> Single<UserNovelDetail> {
        do {
            let request = try makeHTTPRequest(method: .get,
                                               path: URLs.UserNovel.getUserNovel.replacingOccurrences(of: "{userNovelId}", with: String(userNovelId)),
                                               headers: APIConstants.testTokenHeader,
                                               body: nil)
            
            NetworkLogger.log(request: request)
            
            return urlSession.rx.data(request: request)
                .map { try self.decode(data: $0,
                                       to: UserNovelDetail.self) }
                .asSingle()
        } catch {
            return Single.error(error)
        }
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
    
    func postUserNovel(novelId: Int, userNovelRating: Float?, userNovelReadStatus: ReadStatus, userNovelReadStartDate: String?, userNovelReadEndDate: String?) -> Single<UserNovelId> {
        guard let userNovelBasic = try? JSONEncoder()
            .encode(UserNovelBasicInfo(userNovelRating: userNovelRating,
                                       userNovelReadStatus: userNovelReadStatus.rawValue,
                                       userNovelReadStartDate: userNovelReadStartDate,
                                       userNovelReadEndDate: userNovelReadEndDate)
            ) else {
            return Single.error(NetworkServiceError.invalidRequestError)
        }
        do {
            let request = try makeHTTPRequest(method: .post,
                                               path: URLs.UserNovel.postUserNovel.replacingOccurrences(of: "{novelId}", with: String(novelId)),
                                               headers: APIConstants.testTokenHeader,
                                               body: userNovelBasic)
            
            NetworkLogger.log(request: request)
            
            return urlSession.rx.data(request: request)
                .map { try self.decode(data: $0, to: UserNovelId.self) }
                .asSingle()
        } catch {
            return Single.error(error)
        }
    }
    
    func patchUserNovel(userNovelId: Int, userNovelRating: Float?, userNovelReadStatus: ReadStatus, userNovelReadStartDate: String?, userNovelReadEndDate: String?) -> Single<Void> {
        guard let userNovelBasic = try? JSONEncoder()
            .encode(UserNovelBasicInfo(userNovelRating: userNovelRating,
                                       userNovelReadStatus: userNovelReadStatus.rawValue,
                                       userNovelReadStartDate: userNovelReadStartDate,
                                       userNovelReadEndDate: userNovelReadEndDate)
            ) else {
            return Single.error(NetworkServiceError.invalidRequestError)
        }
        do {
            let request = try makeHTTPRequest(method: .patch,
                                               path: URLs.UserNovel.patchUserNovel.replacingOccurrences(of: "{userNovelId}", with: String(userNovelId)),
                                               headers: APIConstants.testTokenHeader,
                                               body: userNovelBasic)
            
            NetworkLogger.log(request: request)
            
            return urlSession.rx.data(request: request)
                .map { _ in }
                .asSingle()
        } catch {
            return Single.error(error)
        }
    }
}
