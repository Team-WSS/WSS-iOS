//
//  CompletedStatus.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 10/23/24.
//

import Foundation

enum CompletedStatus: String, CaseIterable {
    case completed
    case notCompleted
    
    var description: String {
        switch self {
        case .completed: return "완결작"
        case .notCompleted: return "연재중"
        }
    }
    
    var isCompleted: Bool {
        switch self {
        case .completed: return true
        case .notCompleted: return false
        }
    }
    
    init(isCompleted: Bool) {
        self = isCompleted ? .completed : .notCompleted
    }
}
