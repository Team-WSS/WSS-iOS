//
//  StarRatingView.swift
//  WSSiOS
//
//  Created by 이윤학 on 1/7/24.
//

import UIKit

import SnapKit
import Then

final class RegisterNormalStarRatingView: UIView {
    
    // MARK: - Properties
    
    private var selectedRate: Int = 0
    private var starsCount: Int = 5
    
    // MARK: - UI Components
    
    private let starStackView = UIStackView()
    private lazy var starImageViews: [UIImageView] = self.createStars()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setHieararchy()
        setUI()
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
        self.addSubviews(starStackView)
        
        starImageViews.forEach {
            starStackView.addArrangedSubview($0)
        }
    }
    
    private func setLayout() {
        starStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    /// loop through the number of our stars
    private func createStars() -> [UIImageView] {
        var starImageViews: [UIImageView] = []
        for index in 1...starsCount {
            let star = makeStarImageView()
            star.tag = index
            starImageViews.append(star)
        }
        return starImageViews
    }
    
    /// declare default icon
    private func makeStarImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.do {
            $0.image = ImageLiterals.icon.icStar.empty
            $0.isUserInteractionEnabled = true
        }
        return imageView
    }
}
