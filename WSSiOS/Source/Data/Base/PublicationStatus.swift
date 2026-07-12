//
//  CompletedStatus.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 10/23/24.
//

import Foundation

enum PublicationStatus: String, CaseIterable, Codable {
    case onGoing
    case completed
    
    var description: String {
        switch self {
        case .onGoing: return "연재중"
        case .completed: return "완결작"
        }
    }
    
    var isCompleted: Bool {
        switch self {
        case .onGoing: return false
        case .completed: return true
        }
    }
    
    init(isCompleted: Bool) {
        self = isCompleted ? .completed : .onGoing
    }
}
