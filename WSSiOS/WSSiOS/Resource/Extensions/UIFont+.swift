//
//  UIFont+.swift
//  WSSiOS
//
//  Created by 신지원 on 1/3/24.
//

import UIKit

// Font
enum WSSFont {
    case headline1
    case title1, title2, title3
    case body1, body2, body3, body4, body4_2, body5, body5_2
    case label1, label2
    
    var font: UIFont {
        switch self {
        case .headline1: return .HeadLine1
        case .title1: return .Title1
        case .title2: return .Title2
        case .title3: return .Title3
        case .body1: return .Body1
        case .body2: return .Body2
        case .body3: return .Body3
        case .body4: return .Body4
        case .body4_2: return .Body4_2
        case .body5: return .Body5
        case .body5_2: return .Body5_2
        case .label1: return .Label1
        case .label2: return .Label2
        }
    }
    
    var lineHeightMultiple: CGFloat {
        switch self {
        case .headline1: return 1.4
        case .title1: return 1.4
        case .title2: return 1.4
        case .title3: return 1.0
        case .body1: return 1.4
        case .body2: return 1.5
        case .body3: return 1.5
        case .body4: return 1.45
        case .body4_2: return 1.45
        case .body5: return 1.45
        case .body5_2: return 1.45
        case .label1: return 1.45
        case .label2: return 1.0
        }
    }
    
    var kerningPixel: Double {
        switch self {
        case .headline1: return -1.2
        case .title1: return -0.6
        case .title2: return -0.6
        case .title3: return -0.6
        case .body1: return -0.6
        case .body2: return -0.6
        case .body3: return -0.4
        case .body4: return -0.4
        case .body4_2: return -0.4
        case .body5: return 0.0
        case .body5_2: return 0.0
        case .label1: return -0.4
        case .label2: return 0.0
        }
    }
}

extension UIFont {
    static var HeadLine1: UIFont {
        return UIFont(name: "Pretendard-Bold", size: 20)!
    }
    
    static var Title1: UIFont {
        return UIFont(name: "Pretendard-Bold", size: 18)!
    }
    
    static var Title2: UIFont {
        return UIFont(name: "Pretendard-SemiBold", size: 16)!
    }
    
    static var Title3: UIFont {
        return UIFont(name: "Pretendard-Medium", size: 14)!
    }
    
    static var Body1: UIFont {
        return UIFont(name: "Pretendard-Regular", size: 17)!
    }
    
    static var Body2: UIFont {
        return UIFont(name: "Pretendard-Regular", size: 15)!
    }
    
    static var Body3: UIFont {
        return UIFont(name: "Pretendard-Regular", size: 14)!
    }
    
    static var Body4: UIFont {
        return UIFont(name: "Pretendard-Medium", size: 13)!
    }
    
    static var Body4_2: UIFont {
        return UIFont(name: "Pretendard-Regular", size: 13)!
    }
    
    static var Body5: UIFont {
        return UIFont(name: "Pretendard-Regular", size: 12)!
    }
    
    static var Body5_2: UIFont {
        return UIFont(name: "Pretendard-Medium", size: 12)!
    }
    
    static var Label1: UIFont {
        return UIFont(name: "Pretendard-Medium", size: 13)!
    }
    
    static var Label2: UIFont {
        return UIFont(name: "Pretendard-Medium", size: 10)!
    }
}
