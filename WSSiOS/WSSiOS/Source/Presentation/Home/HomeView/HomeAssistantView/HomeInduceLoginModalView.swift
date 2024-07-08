//
//  HomeInduceLoginModalView.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/13/24.
//

import UIKit

import SnapKit
import Then

final class HomeInduceLoginModalView: UIView {
    
    //MARK: - UI Components
    
    private let backgroundView = UIView()
    
    private let backgroundModalView = UIView()
    private let backgroundImageView = UIImageView()
    private let titleLabel = UILabel()
    
    /// 로그인 버튼 및 버튼 내 라벨
    private var loginButton = UIButton()
    private let loginButtonLabel = UILabel()
    
    /// 닫기 버튼 및 버튼 내 라벨
    private var cancelButton = UIButton()
    private let cancelButtonLabel = UILabel()
    
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
        backgroundView.do {
            $0.backgroundColor = .wssBlack60
        }
        
        backgroundModalView.do {
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
            $0.applyWSSFont(.title1, with: StringLiterals.Home.Login.induceTitle)
            $0.textColor = .wssBlack
            $0.textAlignment = .center
            $0.numberOfLines = 2
        }
        
        loginButton.do {
            $0.backgroundColor = .wssPrimary100
            $0.layer.cornerRadius = 8
            
            loginButtonLabel.do {
                $0.applyWSSFont(.label1, with: StringLiterals.Home.Login.loginButtonTitle)
                $0.textColor = .wssWhite
                $0.isUserInteractionEnabled = false
            }
        }
        
        cancelButton.do {
            $0.backgroundColor = .wssWhite
            $0.layer.cornerRadius = 8
            
            cancelButtonLabel.do {
                $0.applyWSSFont(.label1, with: StringLiterals.Home.Login.cancelButtonTitle)
                $0.textColor = .wssGray200
                $0.isUserInteractionEnabled = false
            }
        }
    }
    
    private func setHierarchy() {
        self.addSubview(backgroundView)
        backgroundView.addSubview(backgroundModalView)
        backgroundModalView.addSubviews(backgroundImageView,
                                        loginButton,
                                        cancelButton)
        
        backgroundImageView.addSubview(titleLabel)
        loginButton.addSubview(loginButtonLabel)
        cancelButton.addSubview(cancelButtonLabel)
    }
    
    private func setLayout() {
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        backgroundModalView.snp.makeConstraints {
            $0.width.equalTo(292)
            $0.height.equalTo(390)
            $0.center.equalToSuperview()
        }
        
        backgroundImageView.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(29)
            $0.centerX.equalToSuperview()
        }
        
        loginButton.snp.makeConstraints {
            $0.top.equalTo(backgroundImageView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(21)
            $0.height.equalTo(43)
            
            loginButtonLabel.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
        }
        
        cancelButton.snp.makeConstraints {
            $0.top.equalTo(loginButton.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(21)
            $0.height.equalTo(35)
            
            cancelButtonLabel.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
        }
    }
}
