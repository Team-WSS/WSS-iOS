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
