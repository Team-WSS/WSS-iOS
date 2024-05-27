//
//  SearchDetailInduceView.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/26/24.
//

import UIKit

import SnapKit
import Then

final class SearchDetailInduceView: UIView {
    
    //MARK: - Components
    
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let backgroundImageView = UIImageView()
    private let induceDetailButton = UIButton()
    
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
        self.do {
            $0.backgroundColor = .wssPrimary20
            $0.layer.cornerRadius = 14
        }
        
        titleLabel.do {
            $0.fontTitle1Attribute(with: StringLiterals.Search.induceTitle)
            $0.textColor = .wssBlack
        }
        
        descriptionLabel.do {
            $0.fontLabel1Attribute(with: StringLiterals.Search.induceDescription)
            $0.textColor = .wssGray200
        }
        
        backgroundImageView.do {
            $0.image = .imgInduceSearchDetail
            $0.contentMode = .scaleAspectFill
        }
        
        induceDetailButton.do {
            var configuration = UIButton.Configuration.filled()
            configuration.baseBackgroundColor = .wssWhite
            configuration.baseForegroundColor = .wssPrimary100
            var titleAttr = AttributedString.init(StringLiterals.Search.induceButton)
            titleAttr.kern = -0.6
            titleAttr.font = UIFont.Title3
            configuration.attributedTitle = titleAttr
            configuration.background.cornerRadius = 14
            configuration.contentInsets = NSDirectionalEdgeInsets(top: 14.5, leading: 57.5, bottom: 14.5, trailing: 57.5)
            $0.configuration = configuration
        }
    }
    
    private func setHierarchy() {
        self.addSubview(backgroundImageView)
        backgroundImageView.addSubviews(titleLabel,
                                        descriptionLabel,
                                        induceDetailButton)
    }
    
    private func setLayout() {
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.leading.equalToSuperview().inset(20)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.equalTo(titleLabel.snp.leading)
        }
        
        induceDetailButton.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(113)
            $0.leading.trailing.equalToSuperview().inset(22.5)
            $0.bottom.equalToSuperview().inset(21)
        }
    }
}
