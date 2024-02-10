//
//  SearchEmptyView.swift
//  WSSiOS
//
//  Created by 최서연 on 1/6/24.
//

import UIKit

import SnapKit
import Then

final class SearchEmptyView: UIView {
    
    //MARK: - Components
    
    private let emptyImageView = UIImageView()
    private let emptyDescriptionLabel = UILabel()
    private let emptyButton = UIButton()
    
    //MARK: - Life Cycle
    
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
        emptyImageView.do {
            $0.image = .icBookRegistrationNoresult
        }
        
        emptyDescriptionLabel.do {
            $0.makeAttribute(with: StringLiterals.Search.Empty.description)?
                .kerning(kerningPixel: -0.8)
                .lineSpacing(spacingPercentage: 140)
                .applyAttribute()
            $0.font = .Body1
            $0.textColor = .wssGray200
        }
        
        emptyButton.do {
            var config = UIButton.Configuration.filled()
            config.baseBackgroundColor = .wssPrimary50
            config.baseForegroundColor = .wssPrimary100
            var titleAttr = AttributedString.init(StringLiterals.Search.Empty.register)
            titleAttr.kern = -0.6
            titleAttr.font = UIFont.Title1
            config.attributedTitle = titleAttr
            config.background.cornerRadius = 12
            config.contentInsets = NSDirectionalEdgeInsets(top: 18, leading: 42, bottom: 18, trailing: 42)
            $0.configuration = config
        }
    }

    private func setHierarchy() {
        self.addSubviews(emptyImageView,
                         emptyDescriptionLabel,
                         emptyButton)
    }

    private func setLayout() {
        emptyImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(231)
            $0.centerX.equalToSuperview()
        }
        
        emptyDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(emptyImageView.snp.bottom).offset(9.5)
            $0.centerX.equalToSuperview()
        }
        
        emptyButton.snp.makeConstraints {
            $0.top.equalTo(emptyDescriptionLabel.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
        }
    }
}
