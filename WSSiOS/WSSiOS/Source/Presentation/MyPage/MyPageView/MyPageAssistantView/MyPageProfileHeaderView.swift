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
    
    private let userImageChangeButtonView = MyPageUserImageChangeButtonView()
    
    //MARK: - Components
    
    lazy var settingButton = UIButton()
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
        
        test()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI
    
    private func setUI() {
        self.backgroundColor = .wssPrimary20
        
        settingButton.do {
            $0.setImage(UIImage(resource: .setting), for: .normal)
        }
        
        userImageView.do {
            $0.contentMode = .scaleAspectFill
        }
        
        userImageChangeButton.do {
            var configuration = UIButton.Configuration.filled()
            configuration.background.customView = userImageChangeButtonView
            configuration.baseBackgroundColor = .wssWhite
            
            $0.configuration = configuration
            $0.imageView?.contentMode = .scaleAspectFit
            
            $0.layer.borderWidth = 1.04
            $0.layer.borderColor = UIColor.wssGray70.cgColor
        }
        
        //TODO: - 이 부분 lineHeightMultiple 은 FeedView 머지 후 수정
        userNicknameLabel.do {
            $0.font = .HeadLine1
            $0.textColor = .wssBlack
            $0.numberOfLines = 1
            $0.textAlignment = .center
        }
        
        userIntroLabel.do {
            $0.font = .Body2
            $0.textColor = .wssGray200
            $0.numberOfLines = 0
            $0.textAlignment = .center
        }
    }
    
    private func setHierarchy() {
        addSubviews(settingButton,
                    userImageView,
                    userImageChangeButton,
                    userNicknameLabel,
                    userIntroLabel)
    }
    
    private func setLayout() {
        settingButton.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(1)
            $0.trailing.equalToSuperview().inset(12)
            $0.size.equalTo(44)
        }
        
        userImageView.snp.makeConstraints {
            $0.top.equalTo(settingButton.snp.bottom).offset(25)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(94)
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
            $0.bottom.equalToSuperview().inset(30)
        }
    }
    
    //MARK: - Data
    
    func bindData(data: MyProfileResult) {
        userImageView.kfSetImage(url: data.avatarImage)
        userNicknameLabel.text = data.nickname
        userIntroLabel.text = data.intro
    }
    
    func test() {
        userImageView.backgroundColor = .black
        userNicknameLabel.text = "밝보"
        userIntroLabel.text = "꺄울 로판에 절여진 밝보입니다~"
    }
}

