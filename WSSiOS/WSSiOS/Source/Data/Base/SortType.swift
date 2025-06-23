//
//  Alignment.swift
//  WSSiOS
//
//  Created by YunhakLee on 5/26/25.
//

enum SortType {
    case newest, oldest
    
    var queryText: String {
        switch self {
        case .newest:
            return "NEWEST"
        case .oldest:
            return "OLDEST"
        }
    }
    
    var text: String {
        switch self {
        case .newest:
            return "최신 순"
        case .oldest:
            return "오래된 순"
        }
    }
    
    var lastId: Int {
        switch self {
        case .newest:
            return 0
        case .oldest:
            return 0
        }
    }
    
    var sizeData: Int {
        return 10
    }
    
    func toggle() -> SortType {
        switch self {
        case .newest:
            return .oldest
        case .oldest:
            return .newest
        }
    }
}
