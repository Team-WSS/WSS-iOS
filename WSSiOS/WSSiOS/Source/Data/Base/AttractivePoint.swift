//
//  AttractivePoint.swift
//  WSSiOS
//
//  Created by YunhakLee on 9/8/24.
//

import Foundation

enum AttractivePoint: String {
    case worldview, material, character, relationship, vibe, error
    
    var korean: String {
        switch self {
        case .worldview:
            "세계관"
        case .material:
            "소재"
        case .character:
            "캐릭터"
        case .relationship:
            "관계"
        case .vibe:
            "분위기"
        case .error:
            "에러"
        }
    }
}
