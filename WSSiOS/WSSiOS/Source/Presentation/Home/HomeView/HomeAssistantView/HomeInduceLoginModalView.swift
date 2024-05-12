//
//  HomeInduceLoginModalView.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/13/24.
//

import UIKit

final class HomeInduceLoginModalView: UIView {
    
    //MARK: - UI Components
    
    private var backgroundImageView = UIImageView()
    private var titleLabel = UILabel()
    private var loginButton = UIButton()
    private var cancelButton = UIButton()
    
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
    
    private func setUI() {
        self.do {
            $0.backgroundColor = .wssWhite
            $0.layer.cornerRadius = 12
            $0.layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
            $0.layer.shadowOpacity = 1
            $0.layer.shadowOffset = CGSize(width: 0, height: 2)
            $0.layer.shadowRadius = 15
            $0.layer.masksToBounds = false
        }
        
        backgroundImageView.do {
            $0.image = .imgInduceLogin
        }
        
        titleLabel.do {
            $0.font = .Title1
            $0.textColor = .wssBlack
            $0.makeAttribute(with: StringLiterals.Home.Login.induceTitle)?
                .kerning(kerningPixel: -0.6)
                .lineSpacing(spacingPercentage: 140)
                .applyAttribute()
            $0.textAlignment = .center
            $0.numberOfLines = 2
        }
        
        loginButton.do {
            var configuration = UIButton.Configuration.filled()
            configuration.baseBackgroundColor = .wssPrimary100
            configuration.baseForegroundColor = .wssWhite
            var titleAttr = AttributedString.init(StringLiterals.Home.Login.loginButtonTitle)
            titleAttr.kern = -0.4
            titleAttr.font = UIFont.Label1
            configuration.attributedTitle = titleAttr
            configuration.background.cornerRadius = 8
            configuration.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 82, bottom: 12, trailing: 82)
            $0.configuration = configuration
        }
        
        cancelButton.do {
            var configuration = UIButton.Configuration.filled()
            configuration.baseBackgroundColor = .wssWhite
            configuration.baseForegroundColor = .wssGray200
            var titleAttr = AttributedString.init(StringLiterals.Home.Login.cancelButtonTitle)
            titleAttr.kern = -0.4
            titleAttr.font = UIFont.Label1
            configuration.attributedTitle = titleAttr
            configuration.background.cornerRadius = 8
            configuration.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 113, bottom: 8, trailing: 113)
            $0.configuration = configuration
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(backgroundImageView,
                        loginButton,
                        cancelButton)
        
        backgroundImageView.addSubview(titleLabel)
    }
    
    private func setLayout() {
        self.snp.makeConstraints {
            $0.width.equalTo(292)
            $0.height.equalTo(390)
        }
        
        backgroundImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(29)
            $0.centerX.equalToSuperview()
        }
        
        loginButton.snp.makeConstraints {
            $0.top.equalTo(backgroundImageView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        cancelButton.snp.makeConstraints {
            $0.top.equalTo(loginButton.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
    }
}
