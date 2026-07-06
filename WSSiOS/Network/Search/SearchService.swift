//
//  SearchService.swift
//  WSSiOS
//
//  Created by Guryss on 9/7/24.
//

import Foundation

import RxSwift

protocol SearchService {
    func getSosopicks() -> Single<SosoPickNovels>
    func searchNormalNovels(query: String, page: Int, size: Int) -> Single<NormalSearchNovels>
    func searchDetailNovels(genres: [String],
                            platforms: [String],
                            isCompleted: Bool?,
                            lowerNovelRating: Float,
                            upperNovelRating: Float,
                            keywordIds: [Int],
                            page: Int,
                            size: Int) -> Single<DetailSearchNovels>
    func getRecentSearches() -> Single<[RecentSearch]>
    func deleteRecentSearch(id: Int) -> Single<Void>
    func deleteAllRecentSearches() -> Single<Void>
}

final class DefaultSearchService: NSObject, Networking { }

extension DefaultSearchService: SearchService {
    func getRecentSearches() -> Single<[RecentSearch]> {
        do {
            let request = try makeHTTPRequest(method: .get,
                                              path: URLs.Search.recentSearch,
                                              headers: APIConstants.accessTokenHeader,
                                              body: nil)
            NetworkLogger.log(request: request)
            return tokenCheckURLSession.rx.data(request: request)
                .map { try self.decode(data: $0, to: RecentSearches.self).recentSearches }
                .asSingle()
        } catch {
            return Single.error(error)
        }
    }

    func deleteRecentSearch(id: Int) -> Single<Void> {
        do {
            let request = try makeHTTPRequest(method: .delete,
                                              path: URLs.Search.deleteRecentSearchKeyword(id: id),
                                              headers: APIConstants.accessTokenHeader,
                                              body: nil)
            NetworkLogger.log(request: request)
            return tokenCheckURLSession.rx.data(request: request)
                .map { _ in }
                .asSingle()
        } catch {
            return Single.error(error)
        }
    }

    func deleteAllRecentSearches() -> Single<Void> {
        do {
            let request = try makeHTTPRequest(method: .delete,
                                              path: URLs.Search.deleteAllRecentSearchKeywords,
                                              headers: APIConstants.accessTokenHeader,
                                              body: nil)
            NetworkLogger.log(request: request)
            return tokenCheckURLSession.rx.data(request: request)
                .map { _ in }
                .asSingle()
        } catch {
            return Single.error(error)
        }
    }

    func getSosopicks() -> Single<SosoPickNovels> {
        do {
            let request = try makeHTTPRequest(method: .get,
                                              path: URLs.Search.sosoPick,
                                              headers: APIConstants.accessTokenHeader,
                                              body: nil)
            
            NetworkLogger.log(request: request)
            
            return tokenCheckURLSession.rx.data(request: request)
                .map { try self.decode(data: $0,
                                       to: SosoPickNovels.self) }
                .asSingle()
            
        } catch {
            return Single.error(error)
        }
    }
    
    func searchNormalNovels(query: String, page: Int, size: Int) -> Single<NormalSearchNovels> {
        let normalSearchQueryItems: [URLQueryItem] = [
            URLQueryItem(name: "query", value: String(describing: query)),
            URLQueryItem(name: "page", value: String(describing: page)),
            URLQueryItem(name: "size", value: String(describing: size))
        ]
        
        do {
            let request = try makeHTTPRequest(method: .get,
                                              path: URLs.Search.normalSearch,
                                              queryItems: normalSearchQueryItems,
                                              headers: APIConstants.accessTokenHeader,
                                              body: nil)
            
            NetworkLogger.log(request: request)
            
            return tokenCheckURLSession.rx.data(request: request)
                .map { try self.decode(data: $0,
                                       to: NormalSearchNovels.self) }
                .asSingle()
            
        } catch {
            return Single.error(error)
        }
    }
    
    func searchDetailNovels(genres: [String],
                            platforms: [String],
                            isCompleted: Bool?,
                            lowerNovelRating: Float,
                            upperNovelRating: Float,
                            keywordIds: [Int],
                            page: Int,
                            size: Int) -> Single<DetailSearchNovels> {
        
        var detailSearchQueryItems: [URLQueryItem] = [
            URLQueryItem(name: "genres", value: genres.joined(separator: ",")),
            URLQueryItem(name: "platformNames", value: platforms.joined(separator: ",")),
            URLQueryItem(name: "keywordIds", value: keywordIds.map { String($0) }.joined(separator: ",")),
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "size", value: String(size)),
            URLQueryItem(name: "novelRatingStart", value: String(lowerNovelRating)),
            URLQueryItem(name: "novelRatingEnd", value: String(upperNovelRating))
        ]
        
        if let isCompleted = isCompleted {
            detailSearchQueryItems.append(URLQueryItem(name: "isCompleted", value: String(isCompleted)))
        }

        do {
            let request = try makeHTTPRequest(method: .get,
                                              path: URLs.Search.detailSearch,
                                              queryItems: detailSearchQueryItems,
                                              headers: APIConstants.accessTokenHeader,
                                              body: nil)
            
            NetworkLogger.log(request: request)
            
            return tokenCheckURLSession.rx.data(request: request)
                .map { try self.decode(data: $0,
                                       to: DetailSearchNovels.self) }
                .asSingle()
            
        } catch {
            return Single.error(error)
        }
    }
}
