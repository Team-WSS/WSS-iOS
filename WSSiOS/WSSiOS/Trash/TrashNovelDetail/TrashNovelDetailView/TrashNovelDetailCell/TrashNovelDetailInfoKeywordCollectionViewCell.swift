//
//  TrashNovelDetailInfoKeywordCollectionViewCell.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 1/12/24.
//

import UIKit

import SnapKit
import Then

final class TrashNovelDetailInfoKeywordCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Components

    private let keywordLabel = UILabel()
    
    //MARK: - Life Cycle
    
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
            $0.backgroundColor = .wssGray50
            $0.layer.cornerRadius = 18.5
        }
        
        keywordLabel.do {
            $0.font = .Body2
            $0.textColor = .wssGray300
        }
    }
    
    private func setHierarchy() {
        self.contentView.addSubviews(keywordLabel)
    }
    
    private func setLayout() {
        keywordLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(7)
            $0.leading.trailing.equalToSuperview().inset(13)
        }
    }
    
    //MARK: - Data
    
    func bindData(keyword: String) {
        self.keywordLabel.do {
            $0.makeAttribute(with: keyword)?
                .lineSpacing(spacingPercentage: 150)
                .kerning(kerningPixel: -0.6)
                .applyAttribute()
        }
    }
}
