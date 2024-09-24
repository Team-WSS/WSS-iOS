//
//  ReadStatus.swift
//  WSSiOS
//
//  Created by YunhakLee on 8/16/24.
//

import UIKit

enum ReadStatus: String, CaseIterable {
    case watching = "WATCHING"
    case watched = "WATCHED"
    case quit = "QUIT"
    
    var nameText: String {
        switch self {
        case .watching: return "보는 중"
        case .watched: return "봤어요"
        case .quit: return "하차"
        }
    }
    
    var fillImage: UIImage {
        switch self {
        case .watching: return .icWatchingFill
        case .watched: return .icWatchedFill
        case .quit: return .icQuitFill
        }
    }
    
    var strokeImage: UIImage {
        switch self {
        case .watching: return .icWatchingStroke
        case .watched: return .icWatchedStroke
        case .quit: return .icQuitStroke
        }
    }
    
    var dateText: String? {
        switch self {
        case .watching: return "시작 날짜"
        case .watched: return "읽은 날짜"
        case .quit: return "종료 날짜"
        }
    }
}
