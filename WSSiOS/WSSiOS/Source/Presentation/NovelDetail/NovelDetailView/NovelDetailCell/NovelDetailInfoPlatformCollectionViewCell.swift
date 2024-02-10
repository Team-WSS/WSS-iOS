//
//  NovelDetailInfoPlatformCollectionViewCell.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 1/12/24.
//

import UIKit

import SnapKit
import Then

final class NovelDetailInfoPlatformCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Components

    private let platformLabel = UILabel()
    private let platformImageView = UIImageView()
    
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
        self.do {
            $0.backgroundColor = .wssPrimary50
            $0.layer.cornerRadius = 18.5
        }
        
        platformLabel.do {
            $0.font = .Body2
            $0.textColor = .wssPrimary100
        }
        
        platformImageView.do {
            $0.image = ImageLiterals.icon.linkPlatform
            $0.contentMode = .scaleAspectFit
        }
    }
    
    private func setHierarchy() {
        self.contentView.addSubviews(platformLabel,
                                     platformImageView)
    }
    
    private func setLayout() {
        platformLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(7)
            $0.leading.equalToSuperview().inset(13)
        }
        
        platformImageView.snp.makeConstraints {
            $0.centerY.equalTo(platformLabel.snp.centerY)
            $0.leading.equalTo(platformLabel.snp.trailing).offset(6)
            $0.trailing.equalToSuperview().inset(13)
        }
    }
    
    // MARK: - Data

    func bindData(platform: String) {
        self.platformLabel.do {
            $0.makeAttribute(with: platform)?
                .lineSpacing(spacingPercentage: 150)
                .kerning(kerningPixel: -0.6)
                .applyAttribute()
        }
    }
}
