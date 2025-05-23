//
//  MyPageProfileHeaderView.swift
//  WSSiOS
//
//  Created by 신지원 on 5/29/24.
//

import UIKit

import SnapKit
import Then

final class MyPageProfileHeaderView: UIView {
    
    //MARK: - Properties
    
    private let profileImageSize: CGFloat = 86
    private let profileChangeImageSize: CGFloat = 25
    
    //MARK: - Components
    
    private let userImageView = UIImageView()
    let userImageChangeImageView = UIImageView()
    
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
        self.backgroundColor = .wssWhite
        
        userImageView.do {
            $0.layer.cornerRadius = profileImageSize / 2
            $0.clipsToBounds = true
        }
        
        userImageChangeImageView.do {
            $0.image = .icPencil
            $0.contentMode = .center
            $0.clipsToBounds = true
            $0.layer.cornerRadius = profileChangeImageSize / 2
            $0.isUserInteractionEnabled = true
            $0.backgroundColor = .wssWhite
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.wssGray80.cgColor
        }
        
        userNicknameLabel.do {
            $0.textColor = .wssBlack
            $0.numberOfLines = 1
        }
        
        userIntroLabel.do {
            $0.textColor = .wssGray200
            $0.numberOfLines = 3
            $0.textAlignment = .justified
        }
    }
    
    private func setHierarchy() {
        addSubviews(userImageView,
                    userImageChangeImageView,
                    userNicknameLabel,
                    userIntroLabel)
    }
    
    private func setLayout() {
        userImageView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.size.equalTo(profileImageSize)
        }
        
        userImageChangeImageView.snp.makeConstraints {
            $0.trailing.equalTo(userImageView.snp.trailing)
            $0.bottom.equalTo(userImageView.snp.bottom)
            $0.size.equalTo(profileChangeImageSize)
        }
        
        userNicknameLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(userImageView.snp.trailing).offset(24)
            $0.trailing.equalToSuperview().inset(19)
        }
        
        userIntroLabel.snp.makeConstraints {
            $0.top.equalTo(userNicknameLabel.snp.bottom).offset(2)
            $0.leading.equalTo(userNicknameLabel.snp.leading)
            $0.trailing.equalTo(userNicknameLabel.snp.trailing)
        }
    }
    
    //MARK: - Data
    
    func bindData(data: MyProfileEntity) {
        if data.avatarImageURL == nil {
            userImageView.image = .imgProfile
        } else {
            userImageView.kfSetImage(url: data.avatarImageURL)
        }
        userNicknameLabel.applyWSSFont(.headline1, with: data.nickname)
        userIntroLabel.applyWSSFont(.body4, with: data.introdution)
    }
}
