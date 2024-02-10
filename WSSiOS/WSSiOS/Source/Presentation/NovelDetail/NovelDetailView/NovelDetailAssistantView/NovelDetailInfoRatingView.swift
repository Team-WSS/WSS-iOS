//
//  NovelDetailInfoRatingView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 1/12/24.
//

import UIKit

import SnapKit
import Then

final class NovelDetailInfoRatingView: UIView {

    // MARK: - Components

    private let ratingLabel = UILabel()
    private let ratingStackView = UIStackView()
    private let dividerView = UIView()

    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI
    
    private func setUI() {
        ratingLabel.do {
            $0.makeAttribute(with: StringLiterals.NovelDetail.Info.rating)?
                .kerning(kerningPixel: -0.6)
                .applyAttribute()
            $0.textColor = .wssBlack
            $0.font = .Title1
        }
        
        ratingStackView.do {
            $0.axis = .horizontal
            $0.alignment = .fill
            $0.distribution = .fill
            $0.spacing = 9
        }
        
        dividerView.do {
            $0.backgroundColor = .wssGray70
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(ratingLabel,
                         ratingStackView,
                         dividerView)
    }
    
    private func setLayout() {
        ratingLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(28)
            $0.leading.trailing.equalTo(20)
        }
        
        ratingStackView.snp.makeConstraints {
            $0.top.equalTo(ratingLabel.snp.bottom).offset(10)
            $0.leading.equalTo(20)
            $0.width.equalTo(170)
            $0.height.equalTo(26)
            $0.bottom.equalToSuperview().inset(35)
        }
        
        dividerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    // MARK: - Data
    
    func bindData(rating: Float) {
        self.ratingStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for i in 0...4 {
            let starImageView = UIImageView()
            
            starImageView.do {
                $0.contentMode = .scaleAspectFit
                if rating >= Float(i + 1) {
                    $0.image = ImageLiterals.icon.Star.fill
                } else if rating > Float(i) {
                    $0.image = ImageLiterals.icon.Star.half
                } else {
                    $0.image = ImageLiterals.icon.Star.empty
                }
            }
            
            self.ratingStackView.addArrangedSubview(starImageView)
        }
    }
}
