//
//  UIImage+.swift
//  WSSiOS
//
//  Created by 최서연 on 1/4/24.
//

import UIKit

extension UIImage {
    static func load (named imageName: String) -> UIImage {
        guard let image = UIImage(named: imageName, in: nil, compatibleWith: nil) else {
            return UIImage()
        }
        return image
    }
}
