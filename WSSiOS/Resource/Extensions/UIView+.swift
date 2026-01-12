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
    
    func makeBucketImageURLString(path: String) -> String {
        let bucketURL = Bundle.main.object(forInfoDictionaryKey: Config.Keys.Plist.bucketURL) as? String ?? "Error"
        let scale = Int(UITraitCollection.current.displayScale)
        
        return "\(bucketURL)\(path)@\(scale)x.png"
    }
}
