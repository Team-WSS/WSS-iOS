//
//  UIImage+.swift
//  WSSiOS
//
//  Created by 최서연 on 1/4/24.
//

import UIKit

extension UIImage {
    // CIContext는 생성 비용이 크므로(렌더링 파이프라인 구성) 전역에서 재사용
    private static let blurContext = CIContext()

    func asBlurredBannerImage(radius: CGFloat) -> UIImage {
        guard let ciImage = CIImage(image: self),
              let clampFilter = CIFilter(name: "CIAffineClamp"),
              let blurFilter = CIFilter(name: "CIGaussianBlur") else {
            return self

        }
        clampFilter.setValue(ciImage, forKey: kCIInputImageKey)
        blurFilter.setValue(clampFilter.outputImage, forKey: kCIInputImageKey)
        blurFilter.setValue(radius, forKey: kCIInputRadiusKey)
        guard let output = blurFilter.outputImage,
              let cgimg = Self.blurContext.createCGImage(output, from: ciImage.extent) else {
            return self
        }
        return UIImage(cgImage: cgimg)
    }

    // 블러 연산을 백그라운드 큐에서 수행하고 결과를 메인 스레드로 전달 (메인 스레드 블로킹 방지)
    func asBlurredBannerImage(radius: CGFloat, completion: @escaping (UIImage) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let blurred = self.asBlurredBannerImage(radius: radius)
            DispatchQueue.main.async {
                completion(blurred)
            }
        }
    }
    
    // 이미지 해상도 조절 함수
    func resizedImage(to scale: CGFloat) -> UIImage? {
        let newSize = CGSize(width: size.width * scale, height: size.height * scale)
        UIGraphicsBeginImageContextWithOptions(newSize, false, scale)
        draw(in: CGRect(origin: .zero, size: newSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
}
