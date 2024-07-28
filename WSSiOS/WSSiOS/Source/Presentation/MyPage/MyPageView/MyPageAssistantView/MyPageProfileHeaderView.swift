//
//  MyPageProfileHeaderView.swift
//  WSSiOS
//
//  Created by 신지원 on 5/29/24.
//

import UIKit

import SnapKit
import Then

class CircularImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.width / 2
        self.clipsToBounds = true
    }
}

class CircularButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.width / 2
        self.clipsToBounds = true
    }
}

final class MyPageProfileHeaderView: UIView {
    
    //MARK: - Properties
    
    private let userImageChangeButtonView = UIImageView()
    
    //MARK: - Components

    lazy var userImageChangeButton = CircularButton()
    
    private let userImageView = CircularImageView()
    private let userNicknameLabel = UILabel()
    private let userIntroLabel = UILabel()
    
    // MARK: - Life Cycle
    
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
        self.backgroundColor = .wssPrimary20
        
        userImageChangeButtonView.do {
            $0.image = .pencil
        }
        
        userImageChangeButton.do {
            var configuration = UIButton.Configuration.filled()
            configuration.baseBackgroundColor = .wssWhite
            
            $0.configuration = configuration
            $0.imageView?.contentMode = .scaleAspectFit
            
            $0.layer.borderWidth = 1.04
            $0.layer.borderColor = UIColor.wssGray70.cgColor
        }

        userNicknameLabel.do {
            $0.textColor = .wssBlack
            $0.numberOfLines = 1
        }
        
        userIntroLabel.do {
            $0.textColor = .wssGray200
            $0.numberOfLines = 2
            $0.textAlignment = .center
        }
    }
    
    private func setHierarchy() {
        addSubviews(userImageView,
                    userImageChangeButton,
                    userNicknameLabel,
                    userIntroLabel)
        userImageChangeButton.addSubview(userImageChangeButtonView)
    }
    
    private func setLayout() {        
        userImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(25)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(94)
        }
        
        userImageChangeButtonView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(20)
        }
        
        userImageChangeButton.snp.makeConstraints {
            $0.trailing.equalTo(userImageView.snp.trailing)
            $0.bottom.equalTo(userImageView.snp.bottom)
            $0.size.equalTo(25)
        }
        
        userNicknameLabel.snp.makeConstraints {
            $0.top.equalTo(userImageChangeButton.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        userIntroLabel.snp.makeConstraints {
            $0.top.equalTo(userNicknameLabel.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(250)
            $0.bottom.equalToSuperview().inset(30)
        }
    }
    
    //MARK: - Data
    
    func bindData(data: MyProfileResult) {
        userImageView.kfSetImage(url: data.avatarImage)
        userNicknameLabel.applyWSSFont(.headline1, with: data.nickname)
        userIntroLabel.do {
            $0.applyWSSFont(.body2, with: data.intro)
            $0.textAlignment = .center
        }
    }
}

