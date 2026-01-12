//
//  UserFeedListQuery.swift
//  WSSiOS
//
//  Created by YunhakLee on 7/7/25.
//

import Foundation

struct UserFeedListQuery {
    var lastFeedId: Int
    var size: Int
    var sortCriteria: String
    var isVisible: Bool?
    var isUnVisible: Bool?
    var genreNames: [String]?
}

extension UserFeedListQuery {
    func asQueryItems() -> [URLQueryItem] {
        var items: [URLQueryItem] = [
            URLQueryItem(name: "lastFeedId", value: "\(lastFeedId)"),
            URLQueryItem(name: "size", value: "\(size)"),
            URLQueryItem(name: "sortCriteria", value: sortCriteria)
        ]
        if let isVisible = isVisible {
            items.append(URLQueryItem(name: "isVisible", value: String(isVisible)))
        }
        if let isUnVisible = isUnVisible {
            items.append(URLQueryItem(name: "isUnVisible", value: String(isUnVisible)))
        }
        if let genreNames = genreNames {
            items.append(URLQueryItem(name: "genreNames", value: genreNames.joined(separator: ",")))
        }
        return items
    }
}
