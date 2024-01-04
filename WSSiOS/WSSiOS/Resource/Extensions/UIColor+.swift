//
//  UIColor+.swift
//  WSSiOS
//
//  Created by 신지원 on 1/1/24.
//

import UIKit

extension UIColor {
    convenience init(r: Int, g: Int, b: Int, alpha: CGFloat = 1) {
        self.init(red: CGFloat(r)/255,green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: alpha)
    }
}

extension UIColor {
    class var Primary50: UIColor {
        return UIColor(r:241, g: 239, b: 255)
    }
    
    class var Primary100: UIColor {
        return UIColor(r:99, g: 65, b: 240)
    }
    
    class var Primary200: UIColor {
        return UIColor(r:24, g: 10, b: 63)
    }
    
    class var Secondary100: UIColor {
        return UIColor(r: 255, g: 103, b: 93)
    }
    
    class var White: UIColor {
        return UIColor(r: 255, g: 255, b: 255)
    }
    
    class var Gray50: UIColor {
        return UIColor(r: 244, g: 245, b: 248)
    }
    
    class var Gray70: UIColor {
        return UIColor(r: 223, g: 223, b: 227)
    }
    
    class var Gray100: UIColor {
        return UIColor(r :203, g: 203, b: 209)
    }
    
    class var Gray200: UIColor {
        return UIColor(r: 174, g: 173, b: 179)
    }
    
    class var Gray300: UIColor {
        return UIColor(r: 82, g: 81, b: 95)
    }
    
    class var Black: UIColor {
        return UIColor(r: 17, g: 17, b: 24)
    }
    
    class var GrayToast: UIColor {
        return UIColor(r: 57, g: 66, b: 88)
    }
    
    class var Black60: UIColor {
        return UIColor(r: 0, g: 0, b: 0)
    }
}
