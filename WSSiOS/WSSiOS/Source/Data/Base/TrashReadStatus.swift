//
//  ReadStatus.swift
//  WSSiOS
//
//  Created by 이윤학 on 1/17/24.
//

import UIKit

enum TrashReadStatus: String, CaseIterable {
    case FINISH
    case READING
    case DROP
    case WISH
    
    var tagImage: UIImage {
        switch self {
        case .FINISH: return .icTagFinished
        case .READING: return .icTagReading
        case .DROP: return .icTagStop
        case .WISH: return .icTagStop
        }
    }
    
    var tagText: String {
        switch self {
        case .FINISH: return "봤어요"
        case .READING: return "보는 중"
        case .DROP: return "하차"
        case .WISH: return "d"
        }
    }
    
    var dateText: String? {
        switch self {
        case .FINISH: return "읽은 날짜"
        case .READING: return "시작 날짜"
        case .DROP: return "종료 날짜"
        case .WISH: return "D"
        }
    }
}
