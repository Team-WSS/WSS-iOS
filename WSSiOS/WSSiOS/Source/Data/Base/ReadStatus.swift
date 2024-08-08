//
//  ReadStatus.swift
//  WSSiOS
//
//  Created by 이윤학 on 1/17/24.
//

import UIKit

enum ReadStatus: String, CaseIterable {
    case FINISH
    case READING
    case DROP
    
    var tagImage: UIImage {
        switch self {
        case .FINISH: return .icTagFinished
        case .READING: return .icTagReading
        case .DROP: return .icTagStop
        }
    }
    
    var tagText: String {
        switch self {
        case .FINISH: return "봤어요"
        case .READING: return "보는 중"
        case .DROP: return "하차"
        }
    }
    
    var dateText: String? {
        switch self {
        case .FINISH: return "읽은 날짜"
        case .READING: return "시작 날짜"
        case .DROP: return "종료 날짜"
        }
    }
}
