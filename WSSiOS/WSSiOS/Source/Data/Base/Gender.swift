//
//  Gender.swift
//  WSSiOS
//
//  Created by YunhakLee on 9/28/24.
//

import Foundation

enum OnboardingGender: String, CaseIterable {
    case male = "M"
    case female = "F"
    
    func koreanString() -> String {
        switch self {
        case .male: return "남자"
        case .female: return "여자"
        }
    }
}
