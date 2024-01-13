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

    // MARK: - UI Components
    
    private let ratingLabel = UILabel()
    private let ratingStackView = UIStackView()
    private let dividerView = UIView()

    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierachy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - set UI
    
    private func setUI() {
        ratingLabel.do {
            $0.text = "나의 평가"
            $0.textColor = .Black
            $0.font = .Title1
        }
        
        ratingStackView.do {
            $0.axis = .horizontal
            $0.alignment = .fill
            $0.distribution = .fill
            $0.spacing = 10
        }
        
        dividerView.do {
            $0.backgroundColor = .Gray70
        }
    }
    
    // MARK: - set Hierachy
    
    private func setHierachy() {
        self.addSubviews(ratingLabel,
                         ratingStackView,
                         dividerView)
    }
    
    // MARK: - set Layout
    
    private func setLayout() {
        ratingLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(28)
            $0.leading.trailing.equalTo(20)
        }
        
        ratingStackView.snp.makeConstraints {
            $0.top.equalTo(ratingLabel.snp.bottom).offset(10)
            $0.leading.equalTo(20)
            $0.width.equalTo(195)
            $0.height.equalTo(29)
            $0.bottom.equalToSuperview().inset(35)
        }
        
        dividerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    func bindData(rating: Float) {
        for i in 0...4 {
            let starImageView = UIImageView()
            
            starImageView.do {
                $0.contentMode = .scaleAspectFit
                if rating >= Float(i + 1) {
                    $0.image = ImageLiterals.icon.icStar.fill
                } else if rating > Float(i) {
                    $0.image = ImageLiterals.icon.icStar.half
                } else {
                    $0.image = ImageLiterals.icon.icStar.empty
                }
            }
            
            self.ratingStackView.addArrangedSubview(starImageView)
        }
    }
}
