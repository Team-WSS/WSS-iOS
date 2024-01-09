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
}
