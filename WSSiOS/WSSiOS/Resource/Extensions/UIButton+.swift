//
//  UIButton+.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 1/11/24.
//

import UIKit

extension UIButton {
    func setButtonAttributedTitle(text: String, font: UIFont, color: UIColor) {
        let attributedString = NSMutableAttributedString(string: text, attributes: [.font: font, .foregroundColor: color])
        
        self.setAttributedTitle(attributedString, for: .normal)
    }
}
