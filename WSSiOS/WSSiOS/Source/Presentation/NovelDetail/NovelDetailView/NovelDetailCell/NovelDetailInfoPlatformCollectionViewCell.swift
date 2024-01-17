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
    
    static let identifier: String = "NovelDetailInfoPlatformCollectionViewCell"
    
    // MARK: - UI Components
    
    private let platformLabel = UILabel()
    private let platformImageView = UIImageView()
    
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
        self.do {
            $0.backgroundColor = .Primary50
            $0.layer.cornerRadius = 18.5
        }
        
        platformLabel.do {
            $0.font = .Body2
            $0.textColor = .Primary100
        }
        
        platformImageView.do {
            $0.image = ImageLiterals.icon.linkPlatform
            $0.contentMode = .scaleAspectFit
        }
    }
    
    // MARK: - set Hierachy
    
    private func setHierachy() {
        self.contentView.addSubviews(platformLabel,
                                     platformImageView)
    }
    
    // MARK: - set Layout
    
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
    
    // MARK: - bind data
    
    func bindData(platform: String) {
        self.platformLabel.do {
            $0.makeAttribute(with: platform)?
                .lineSpacing(spacingPercentage: 150)
                .kerning(kerningPixel: -0.6)
                .applyAttribute()
        }
    }
}
