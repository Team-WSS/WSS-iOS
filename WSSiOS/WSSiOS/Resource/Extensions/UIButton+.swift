//
//  UIButton+.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 1/11/24.
//

import UIKit

import Kingfisher

extension UIButton {
    func setButtonAttributedTitle(text: String, font: UIFont, color: UIColor) {
        let attributedString = NSMutableAttributedString(string: text, attributes: [.font: font, .foregroundColor: color])
        
        self.setAttributedTitle(attributedString, for: .normal)
    }
    
    func kfSetButtonImage(url : String, state: UIControl.State) {
        if let url = URL(string: url) {
            kf.setImage(with: url,
                        for: state, placeholder: nil,
                        options: [.transition(.fade(1.0))],
                        progressBlock: nil)
        }
    }
}

final class DifferentRadiusButton: UIButton {
    var topLeftRadius: CGFloat = 0.0
    var topRightRadius: CGFloat = 0.0
    var bottomLeftRadius: CGFloat = 0.0
    var bottomRightRadius: CGFloat = 0.0

    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()

        path.move(to: CGPoint(x: rect.minX + topLeftRadius, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - topRightRadius, y: rect.minY))
        path.addArc(withCenter: CGPoint(x: rect.maxX - topRightRadius, y: rect.minY + topRightRadius),
                    radius: topRightRadius,
                    startAngle: CGFloat(-Double.pi / 2),
                    endAngle: 0,
                    clockwise: true)

        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - bottomRightRadius))
        path.addArc(withCenter: CGPoint(x: rect.maxX - bottomRightRadius, y: rect.maxY - bottomRightRadius),
                    radius: bottomRightRadius,
                    startAngle: 0,
                    endAngle: CGFloat(Double.pi / 2),
                    clockwise: true)

        path.addLine(to: CGPoint(x: rect.minX + bottomLeftRadius, y: rect.maxY))
        path.addArc(withCenter: CGPoint(x: rect.minX + bottomLeftRadius, y: rect.maxY - bottomLeftRadius),
                    radius: bottomLeftRadius,
                    startAngle: CGFloat(Double.pi / 2),
                    endAngle: CGFloat(Double.pi),
                    clockwise: true)

        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + topLeftRadius))
        path.addArc(withCenter: CGPoint(x: rect.minX + topLeftRadius, y: rect.minY + topLeftRadius),
                    radius: topLeftRadius,
                    startAngle: CGFloat(Double.pi),
                    endAngle: CGFloat(-Double.pi / 2),
                    clockwise: true)

        path.close()

        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        layer.mask = maskLayer
    }
}
