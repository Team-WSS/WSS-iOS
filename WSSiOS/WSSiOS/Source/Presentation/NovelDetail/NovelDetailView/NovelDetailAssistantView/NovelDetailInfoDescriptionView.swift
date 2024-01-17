//
//  NovelDetailInfoDescriptionView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 1/12/24.
//

import UIKit

import SnapKit
import Then

final class NovelDetailInfoDescriptionView: UIView {

    // MARK: - UI Components
    
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
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
        titleLabel.do {
            $0.makeAttribute(with: "작품 소개")?
                .kerning(kerningPixel: -0.6)
                .applyAttribute()
            $0.textColor = .Black
            $0.font = .Title1
        }
        
        descriptionLabel.do {
            $0.textColor = .Gray300
            $0.font = .Body2
            $0.numberOfLines = 0
        }
    }
    
    // MARK: - set Hierachy
    
    private func setHierachy() {
        self.addSubviews(titleLabel,
                         descriptionLabel)
    }
    
    // MARK: - set Layout
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(35)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
        }
    }
    
    func bindData(description: String) {
        self.descriptionLabel.do {
            $0.makeAttribute(with: description)?
                .lineSpacing(spacingPercentage: 150)
                .kerning(kerningPixel: -0.6)
                .applyAttribute()
            $0.lineBreakStrategy = .hangulWordPriority
        }
    }
}
