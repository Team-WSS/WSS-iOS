//
//  NovelRatingStatus.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 10/23/24.
//

import Foundation

enum NovelRatingStatus: String, CaseIterable {
    case aboveThreePointFive
    case aboveFourPointZero
    case aboveFourPointFive
    case aboveFourPointEight
    
    var toFloat: Float {
        switch self {
        case .aboveThreePointFive: return 3.5
        case .aboveFourPointZero: return 4.0
        case .aboveFourPointFive: return 4.5
        case .aboveFourPointEight: return 4.8
        }
    }
    
    var description: String {
        switch self {
        case .aboveThreePointFive: return "3.5이상"
        case .aboveFourPointZero: return "4.0이상"
        case .aboveFourPointFive: return "4.5이상"
        case .aboveFourPointEight: return "4.8이상"
        }
    }
}
