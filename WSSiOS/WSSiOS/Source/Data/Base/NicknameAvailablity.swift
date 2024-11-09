//
//  NicknameAvailablity.swift
//  WSSiOS
//
//  Created by YunhakLee on 10/6/24.
//

import UIKit

enum NicknameAvailablity: Equatable {
    case available
    case notAvailable(reason: NicknameNotAvailableReason)
    case unknown
    case notStarted
    
    func description() -> String {
        switch self {
        case .available:
            return "사용 가능한 닉네임이에요"
        case .notAvailable(reason: let reason):
            return reason.description()
        default :
            return ""
        }
    }
    
    func descriptionIsHidden() -> Bool {
        switch self {
        case .notStarted, .unknown:
            return true
        case .notAvailable, .available:
            return false
        }
    }
    
    func color() -> UIColor {
        switch self {
        case .available:
            return .wssPrimary100
        case .notAvailable :
            return .wssSecondary100
        default :
            return .wssBlack
        }
    }
}

enum NicknameNotAvailableReason {
    case invalidChacterOrLimitExceeded
    case whiteSpaceIncluded
    case duplicated
    case notChanged
    
    func description() -> String {
        switch self {
        case .invalidChacterOrLimitExceeded:
            return "한글, 영문, 숫자 2~10자까지 입력 가능해요"
        case .whiteSpaceIncluded:
            return "공백은 포함될 수 없어요 "
        case .duplicated:
            return "이미 사용 중인 닉네임이에요"
        case .notChanged:
            return "현재 사용 중인 닉네임이에요"
        }
    }
}
