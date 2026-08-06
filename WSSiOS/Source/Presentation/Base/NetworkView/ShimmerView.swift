//
//  ShimmerView.swift
//  WSSiOS
//
//  Created by Claude on 8/4/26.
//

import UIKit

// 스켈레톤 placeholder에 붙이는 shimmer(반짝임) 애니메이션 뷰.
final class ShimmerView: UIView {

    private let gradientLayer = CAGradientLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .wssGray20
        setupGradientLayer()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    private func setupGradientLayer() {
        gradientLayer.colors = [
            UIColor.wssGray20.cgColor,
            UIColor.wssGray50.cgColor,
            UIColor.wssGray20.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.locations = [0, 0.5, 1]
        layer.addSublayer(gradientLayer)
    }

    func startShimmering() {
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1.0, -0.5, 0.0]
        animation.toValue = [1.0, 1.5, 2.0]
        animation.duration = 1.2
        animation.repeatCount = .infinity
        gradientLayer.add(animation, forKey: "shimmer")
    }

    func stopShimmering() {
        gradientLayer.removeAnimation(forKey: "shimmer")
    }
}
