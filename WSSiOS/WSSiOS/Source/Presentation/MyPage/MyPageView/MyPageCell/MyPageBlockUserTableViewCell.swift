//
//  MyPageBlockUserTableViewCell.swift
//  WSSiOS
//
//  Created by 신지원 on 7/29/24.
//

import UIKit

import SnapKit
import Then

final class MyPageBlockUserTableViewCell: UITableViewCell {
    
    //MARK: - Components
    
    private var userImageView = UIImageView()
    private var userNicknameLabel = UILabel()
    private var unblockButton = UIButton()
    
    //MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI
    
    private func setUI() {
        userImageView.do {
            $0.image = .imgProfile
            $0.layer.cornerRadius = 14
            $0.contentMode = .scaleAspectFill
        }
        
        userNicknameLabel.do {
            $0.textColor = .wssBlack
        }
        
        unblockButton.do {
            $0.setTitle(StringLiterals.MyPage.BlockUser.buttonTitle, for: .normal)
            $0.setTitleColor(.wssGray300, for: .normal)
            $0.layer.cornerRadius = 20
            $0.titleLabel?.applyWSSFont(.body3, with: StringLiterals.MyPage.BlockUser.buttonTitle)
            $0.layer.backgroundColor = UIColor.wssGray50.cgColor
        }
    }
    
    
    private func setHierarchy() {
        self.addSubviews(userImageView,
        userNicknameLabel,
        unblockButton)
    }
    
    
    private func setLayout() {
        userImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
            $0.size.equalTo(50)
        }
        
        userNicknameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(userImageView.snp.trailing).offset(14)
        }
        
        unblockButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
            $0.width.equalTo(77)
            $0.height.equalTo(35)
        }
    }
    
    //MARK: - Data
    
    func bindData(image: UIImage, nickname: String) {
        userImageView.image = image
        userNicknameLabel.applyWSSFont(.body2, with: nickname)
    }
}

