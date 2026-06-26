//
//  MyLibraryListQuery.swift
//  WSSiOS
//
//  Created by YunhakLee on 6/27/25.
//

import Foundation

struct MyLibraryNovelListQuery {
    var size: Int
    var sortType: String
    var cursor: String? = nil
    var isInterest: Bool? = nil
    var readStatuses: [String]? = nil
    var genres: [String]? = nil
    var isCompleted: Bool? = nil
    var ratingMin: Float? = nil
    var ratingMax: Float? = nil
    var unratedOnly: Bool? = nil
    var attractivePoints: [String]? = nil
    var keywords: [String]? = nil
}

extension MyLibraryNovelListQuery {
    func asQueryItems() -> [URLQueryItem] {
        var items: [URLQueryItem] = [
            URLQueryItem(name: "size", value: "\(size)"),
            URLQueryItem(name: "sortType", value: sortType)
        ]
        if let cursor = cursor {
            items.append(URLQueryItem(name: "cursor", value: cursor))
        }
        if let isInterest = isInterest {
            items.append(URLQueryItem(name: "isInterest", value: String(isInterest)))
        }
        if let readStatuses = readStatuses {
            items.append(URLQueryItem(name: "readStatuses", value: readStatuses.joined(separator: ",")))
        }
        if let genres = genres {
            items.append(URLQueryItem(name: "genres", value: genres.joined(separator: ",")))
        }
        if let isCompleted = isCompleted {
            items.append(URLQueryItem(name: "isCompleted", value: String(isCompleted)))
        }
        if let ratingMin = ratingMin {
            items.append(URLQueryItem(name: "ratingMin", value: String(ratingMin)))
        }
        if let ratingMax = ratingMax {
            items.append(URLQueryItem(name: "ratingMax", value: String(ratingMax)))
        }
        if let unratedOnly = unratedOnly {
            items.append(URLQueryItem(name: "unratedOnly", value: String(unratedOnly)))
        }
        if let attractivePoints = attractivePoints {
            items.append(URLQueryItem(name: "attractivePoints", value: attractivePoints.joined(separator: ",")))
        }
        if let keywords = keywords {
            items.append(URLQueryItem(name: "keywords", value: keywords.joined(separator: ",")))
        }
        return items
    }
}
