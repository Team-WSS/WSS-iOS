//
//  UserPageProfileHeaderView.swift
//  WSSiOS
//
//  Created by 신지원 on 5/20/25.
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

final class UserPageProfileHeaderView: UIView {
    
    //MARK: - Components
    
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
                    userNicknameLabel,
                    userIntroLabel)
    }
    
    private func setLayout() {
        userImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(25)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(94)
        }
        
        userNicknameLabel.snp.makeConstraints {
            $0.top.equalTo(userImageView.snp.bottom).offset(20)
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
    
    func bindData(data: OtherProfileEntity) {
        userImageView.kfSetImage(url: data.avatarImageURL)
        userNicknameLabel.applyWSSFont(.headline1, with: data.nickname)
        userIntroLabel.do {
            $0.applyWSSFont(.body2, with: data.intro)
            $0.textAlignment = .center
        }
    }
}
