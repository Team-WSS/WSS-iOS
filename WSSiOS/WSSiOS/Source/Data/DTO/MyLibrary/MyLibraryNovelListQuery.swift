//
//  MyLibraryListQuery.swift
//  WSSiOS
//
//  Created by YunhakLee on 6/27/25.
//

import Foundation

struct MyLibraryNovelListQuery {
    var lastUserNovelId: Int
    var size: Int
    var sortType: String
    var isInterest: Bool? = nil
    var readStatus: [String]? = nil
    var attractivePoints: [String]? = nil
    var novelRating: Float? = nil
    var query: String? = nil
    var updatedSince: String? = nil
}

extension MyLibraryNovelListQuery {
    func asQueryItems() -> [URLQueryItem] {
        var items: [URLQueryItem] = [
            URLQueryItem(name: "lastUserNovelId", value: "\(lastUserNovelId)"),
            URLQueryItem(name: "size", value: "\(size)"),
            URLQueryItem(name: "sortCriteria", value: sortType)
        ]
        if let isInterest = isInterest {
            items.append(URLQueryItem(name: "isInterest", value: String(isInterest)))
        }
        if let readStatus = readStatus {
            items.append(URLQueryItem(name: "readStatuses", value: readStatus.joined(separator: ",")))
        }
        if let attractivePoints = attractivePoints {
            items.append(URLQueryItem(name: "attractivePoints", value: attractivePoints.joined(separator: ",")))
        }
        if let novelRating = novelRating {
            items.append(URLQueryItem(name: "novelRating", value: String(novelRating)))
        }
        if let query = query {
            items.append(URLQueryItem(name: "query", value: query))
        }
        if let updatedSince = updatedSince {
            items.append(URLQueryItem(name: "updatedSince", value: updatedSince))
        }
        return items
    }
}
