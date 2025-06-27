//
//  MyLibraryListQuery.swift
//  WSSiOS
//
//  Created by YunhakLee on 6/27/25.
//

import Foundation

struct MyLibraryListQuery {
    let lastUserNovelId: Int
    let size: Int
    let sortType: String
    let isInterest: Bool?
    let readStatus: [String]?
    let attractivePoints: [String]?
    let novelRating: Float?
    let query: String?
    let updatedSince: String?
}

extension MyLibraryListQuery {
    func asQueryItems() -> [URLQueryItem] {
        var items: [URLQueryItem] = [
            URLQueryItem(name: "lastUserNovelId", value: "\(lastUserNovelId)"),
            URLQueryItem(name: "size", value: "\(size)"),
            URLQueryItem(name: "sortType", value: sortType)
        ]
        if let isInterest = isInterest {
            items.append(URLQueryItem(name: "isInterest", value: String(isInterest)))
        }
        if let readStatus = readStatus {
            for status in readStatus {
                items.append(URLQueryItem(name: "readStatus", value: status))
            }
        }
        if let attractivePoints = attractivePoints {
            for point in attractivePoints {
                items.append(URLQueryItem(name: "attractivePoints", value: point))
            }
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
