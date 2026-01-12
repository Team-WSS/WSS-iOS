//
//  UIStackView+.swift
//  WSSiOS
//
//  Created by 최서연 on 1/9/24.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach { self.addArrangedSubview($0) }
    }
}
