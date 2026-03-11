//
//  AttractivePoints.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 9/24/24.
//

import UIKit

enum AttractivePoint: String, CaseIterable, Codable {
    case worldview = "worldview"
    case material = "material"
    case writingSkill = "writingskill"
    case character = "character"
    case relationship = "relationship"
    case vibe = "vibe"
    
    var koreanString: String {
        switch self {
        case .worldview: "세계관"
        case .material: "소재"
        case .writingSkill: "필력"
        case .character: "캐릭터"
        case .relationship: "관계"
        case .vibe: "분위기"
        }
    }
    
    var image: UIImage {
        switch self {
        case .worldview: .icAttractiveWorldview
        case .material: .icAttractiveMaterial
        //TODO: - 필력 아이콘 이미지 변경 필요
        case .writingSkill: .icAttractiveVibe
        case .character: .icAttractiveCharacter
        case .relationship: .icAttractiveRelationship
        case .vibe: .icAttractiveVibe
        }
    }
}
