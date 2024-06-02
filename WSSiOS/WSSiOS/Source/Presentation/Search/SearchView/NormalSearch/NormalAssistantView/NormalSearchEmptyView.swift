//
//  NormalSearchEmptyView.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/27/24.
//

import UIKit

import SnapKit
import Then

final class NormalSearchEmptyView: UIView {
    
    //MARK: - Components
    
    private let stackView = UIStackView()
    private let emptyImageView = UIImageView()
    private let descriptionLabel = UILabel()
    let inquiryButton = UIButton()
    
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
        stackView.do {
            $0.axis = .vertical
            $0.alignment = .center
        }
        
        emptyImageView.do {
            $0.image = .imgEmpty
        }
        
        descriptionLabel.do {
            $0.fontBody1Attribute(with: StringLiterals.Search.Empty.description)
            $0.textColor = .wssGray200
            $0.numberOfLines = 2
        }
        
        inquiryButton.do {
            var configuration = UIButton.Configuration.filled()
            configuration.baseBackgroundColor = .wssPrimary50
            configuration.baseForegroundColor = .wssPrimary100
            var titleAttr = AttributedString.init(StringLiterals.Search.Empty.inquiryButton)
            titleAttr.kern = -0.6
            titleAttr.font = UIFont.Title2
            configuration.attributedTitle = titleAttr
            configuration.background.cornerRadius = 14
            configuration.contentInsets = NSDirectionalEdgeInsets(top: 18, leading: 42, bottom: 18, trailing: 42)
            $0.configuration = configuration
        }
    }
    
    private func setHierarchy() {
        stackView.addArrangedSubviews(emptyImageView,
                                      descriptionLabel,
                                      inquiryButton)
        self.addSubview(stackView)
    }
    
    private func setLayout() {
        stackView.do {
            $0.setCustomSpacing(8, after: emptyImageView)
            $0.setCustomSpacing(36, after: descriptionLabel)
        }
        
        stackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
    }
}

