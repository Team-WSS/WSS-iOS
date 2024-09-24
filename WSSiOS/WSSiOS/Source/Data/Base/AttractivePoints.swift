//
//  AttractivePoints.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 9/24/24.
//

import Foundation

enum AttractivePoints: String, CaseIterable {
    case worldview = "worldview"
    case material = "material"
    case character = "character"
    case relationship = "relationship"
    case vibe = "vibe"
    
    var koreanString: String {
        switch self {
        case .worldview: "세계관"
        case .material: "소재"
        case .character: "캐릭터"
        case .relationship: "관계"
        case .vibe: "분위기"
        }
    }
}
