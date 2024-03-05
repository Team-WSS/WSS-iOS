//
//  UIImage+.swift
//  WSSiOS
//
//  Created by 최서연 on 1/4/24.
//

import UIKit

extension UIImage {
    func asBlurredBannerImage(radius: CGFloat) -> UIImage {
        let context = CIContext()
        guard let ciImage = CIImage(image: self),
              let clampFilter = CIFilter(name: "CIAffineClamp"),
              let blurFilter = CIFilter(name: "CIGaussianBlur") else {
            return self

        }
        clampFilter.setValue(ciImage, forKey: kCIInputImageKey)
        blurFilter.setValue(clampFilter.outputImage, forKey: kCIInputImageKey)
        blurFilter.setValue(radius, forKey: kCIInputRadiusKey)
        guard let output = blurFilter.outputImage,
                let cgimg = context.createCGImage(output, from: ciImage.extent) else {
            return self
        }
        return UIImage(cgImage: cgimg)
    }
}
