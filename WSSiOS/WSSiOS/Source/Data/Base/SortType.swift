//
//  Alignment.swift
//  WSSiOS
//
//  Created by YunhakLee on 5/26/25.
//

enum SortType: Equatable {
    case newest, oldest
    
    var queryText: String {
        switch self {
        case .newest:
            return "RECENT"
        case .oldest:
            return "OLD"
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
    
    static func fromText(_ text: String) -> SortType? {
        switch text {
        case "최신 순":
            return .newest
        case "오래된 순":
            return .oldest
        default:
            return nil
        }
    }
}
