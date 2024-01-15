//
//  RegisterNormalStarRatingView.swift
//  WSSiOS
//
//  Created by 이윤학 on 1/13/24.
//

import UIKit

import SnapKit
import Then

final class RegisterNormalStarRatingView: UIView {
    
    // MARK: - UI Components
    
    lazy var starImageViews: [UIImageView] = createStars()
    private let starStackView = UIStackView()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHieararchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Method
    
    private func setUI() {
        starStackView.do {
            $0.axis = .horizontal
            $0.spacing = 10
        }
    }
    
    private func setHieararchy() {
        self.addSubview(starStackView)
        starImageViews.forEach {
            starStackView.addArrangedSubview($0)
        }
    }
    
    func setLayout() {
        starStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        starImageViews.forEach {
            $0.snp.makeConstraints {
                $0.width.equalTo(31)
                $0.height.equalTo(29)
            }
        }
    }
    
    private func createStars() -> [UIImageView] {
        var stars: [UIImageView] = []
        for _ in 0..<5 {
            let starImageView = UIImageView()
            starImageView.do {
                $0.isUserInteractionEnabled = true
                $0.image = ImageLiterals.icon.Star.empty
                $0.contentMode = .scaleAspectFill
                $0.clipsToBounds = true
            }
            stars.append(starImageView)
        }
        
        return stars
    }
    /// 별점에 따라 별 이미지를 업데이트하는 함수
    func updateStarImages(rating: Float) {
        let fullStars = Int(rating)
        let hasHalfStar = rating - Float(fullStars) >= 0.5
        
        starImageViews.enumerated().forEach { index, imageView in
            if index < fullStars {
                imageView.image = ImageLiterals.icon.Star.fill
            } else if hasHalfStar && index == fullStars {
                imageView.image = ImageLiterals.icon.Star.half
            } else {
                imageView.image = ImageLiterals.icon.Star.empty
            }
        }
        print(rating)
    }
}
