//
//  FeedPageBarCollectionViewCell.swift
//  WSSiOS
//
//  Created by 신지원 on 5/19/24.
//

import UIKit

import SnapKit
import Then

final class FeedPageBarCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Components
    
    private let titleLabel = UILabel()
    
    //MARK: - Life Cycle
    
    override var isSelected: Bool {
        didSet {
            setUI()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI
    
    private func setUI() {
        self.do {
            $0.backgroundColor = isSelected ? .wssBlack : .wssGray50
            $0.layer.cornerRadius = 18
        }
        
        titleLabel.do {
            $0.font = .Title3
            $0.textColor = isSelected ? .wssWhite : .wssGray300
        }
    }
    
    private func setHierarchy() {
        addSubview(titleLabel)
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    //MARK: - Data
    
    func bindData(text: String) {
        titleLabel.do {
            $0.text = text
            $0.makeAttribute(with: $0.text)?
                .lineSpacing(spacingPercentage: 0)
                .kerning(kerningPixel: -0.6)
                .applyAttribute()
        }
    }
}
