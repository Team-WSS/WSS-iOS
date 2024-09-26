//
//  NovelDetailFeedConnectedNovelView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 9/27/24.
//

import UIKit

import SnapKit
import Then

final class NovelDetailFeedConnectedNovelView: UIView {

    //MARK: - Components
    
    private let linkImageView = UIImageView()
    private let titleLabel = UILabel()
    private let starImageView = UIImageView()
    private let ratingLabel = UILabel()
    private let arrowImageView = UIImageView()
    
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
    
    //MARK: - UI
    
    private func setUI() {
        self.do {
            $0.backgroundColor = .wssPrimary20
            $0.layer.cornerRadius = 14
        }
        
        linkImageView.do {
            $0.image = .icNovelLink
        }
        
        titleLabel.do {
            $0.textColor = .wssBlack
        }
        
        starImageView.do {
            $0.image = .icLinkStar
        }
        
        ratingLabel.do {
            $0.textColor = .wssBlack
        }
        
        arrowImageView.do {
            $0.image = .icNavigateRight
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(linkImageView,
                         titleLabel,
                         starImageView,
                         ratingLabel,
                         arrowImageView)
    }
    
    private func setLayout() {
        linkImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
            $0.top.bottom.equalToSuperview().inset(14)
            $0.size.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(linkImageView.snp.trailing).offset(6)
            $0.trailing.equalTo(starImageView.snp.leading).offset(-24)
        }
        
        starImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(ratingLabel.snp.leading).offset(-5)
            $0.size.equalTo(12)
        }
        
        ratingLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(arrowImageView.snp.leading).offset(-10)
        }
        
        arrowImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(14)
            $0.size.equalTo(18)
        }
    }
    
    //MARK: - Data
    
    func bindData(title: String, novelRatingCount: Int, novelRating: Float) {
        titleLabel.do {
            $0.applyWSSFont(.title3, with: title)
            $0.lineBreakMode = .byTruncatingTail
        }
        
        ratingLabel.do {
            $0.applyWSSFont(.body4, with: "\(novelRating) (\(novelRatingCount))")
        }
    }
}
