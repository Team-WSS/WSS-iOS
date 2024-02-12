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

    //MARK: - Components
    
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
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
        titleLabel.do {
            $0.makeAttribute(with: StringLiterals.NovelDetail.Info.description)?
                .kerning(kerningPixel: -0.6)
                .applyAttribute()
            $0.textColor = .wssBlack
            $0.font = .Title1
        }
        
        descriptionLabel.do {
            $0.textColor = .wssGray300
            $0.font = .Body2
            $0.numberOfLines = 0
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(titleLabel,
                         descriptionLabel)
    }
    
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
    
    //MARK: - Data
    
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
