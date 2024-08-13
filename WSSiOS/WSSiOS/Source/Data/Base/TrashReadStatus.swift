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


//
//  ReadStatus.swift
//  WSSiOS
//
//  Created by 이윤학 on 1/17/24.
//

import UIKit

enum ReadStatus: String, CaseIterable {
    case watched
    case watching
    case quit
    
    var tagImage: UIImage {
        switch self {
        case .watched: return .icTagFinished
        case .watching: return .icTagReading
        case .quit: return .icTagStop
        }
    }
    
    var tagText: String {
        switch self {
        case .watched: return "봤어요"
        case .watching: return "보는 중"
        case .quit: return "하차"
        }
    }
    
    var dateText: String? {
        switch self {
        case .watched: return "읽은 날짜"
        case .watching: return "시작 날짜"
        case .quit: return "종료 날짜"
        }
    }
}
