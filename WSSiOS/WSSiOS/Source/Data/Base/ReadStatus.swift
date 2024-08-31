//
//  ReadStatus.swift
//  WSSiOS
//
//  Created by YunhakLee on 8/16/24.
//

import UIKit

enum ReadStatus: String, CaseIterable {
    case watching
    case watched
    case quit
    
    var Image: UIImage {
        switch self {
        case .watching: return .icTagReading
        case .watched: return .icTagFinished
        case .quit: return .icTagStop
        }
    }
    
    var nameText: String {
        switch self {
        case .watching: return "보는 중"
        case .watched: return "봤어요"
        case .quit: return "하차"
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
