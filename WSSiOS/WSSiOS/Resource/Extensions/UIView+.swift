//
//  UIView+.swift
//  WSSiOS
//
//  Created by 최서연 on 1/7/24.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { self.addSubview($0) }
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func makeBucketImageURLString(path: String) -> String {
        let bucketURL = Bundle.main.object(forInfoDictionaryKey: Config.Keys.Plist.bucketURL) as? String ?? "Error"
        let scale = Int(UITraitCollection.current.displayScale)
        
        return "\(bucketURL)\(path)@\(scale)x.png"
    }
}
