//
//  FeedUserView.swift
//  WSSiOS
//
//  Created by 신지원 on 5/15/24.
//

import UIKit

import SnapKit
import Then

final class FeedUserView: UIView {
    
    //MARK: - Components
    
    private let userImageView = UIImageView()
    private let userNicknameLabel = UILabel()
    private let dotIcon = UIImageView()
    private let restTimeLabel = UILabel()
    private let modifiedLabel = UILabel()
    private let dropdownIcon = UIImageView()
    
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
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 12
        }
        
        userNicknameLabel.do {
            $0.textColor = .wssBlack
        }
        
        dotIcon.do {
            $0.image = UIImage(resource: .icDot)
        }
        
        restTimeLabel.do {
            $0.textColor = .wssBlack
        }
        
        modifiedLabel.do {
            $0.applyWSSFont(.body5, with: StringLiterals.Feed.modifiedText)
            $0.textColor = .wssGray200
            $0.isHidden = true
        }
        
        dropdownIcon.do {
            $0.image = UIImage(resource: .icDropDownDot)
        }
    }
    
    private func setHierarchy() {
        addSubviews(userImageView,
                    userNicknameLabel,
                    dotIcon,
                    restTimeLabel,
                    modifiedLabel,
                    dropdownIcon)
    }
    
    private func setLayout() {
        userImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.size.equalTo(36)
        }
        
        userNicknameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(userImageView.snp.trailing).offset(14)
        }
        
        dotIcon.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(userNicknameLabel.snp.trailing).offset(6)
            $0.size.equalTo(8)
        }
        
        restTimeLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(dotIcon.snp.trailing).offset(6)
        }
        
        modifiedLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(restTimeLabel.snp.trailing).offset(6)
        }
        
        //TODO: - 추후 extension 으로 수정
        dropdownIcon.snp.makeConstraints {
            $0.centerY.trailing.equalToSuperview()
            $0.size.equalTo(18)
        }
    }
    
    //MARK: - Data
    
    func bindData(imageURL: String, nickname: String, createdDate: String, isModified: Bool) {
        userImageView.do {
            $0.kfSetImage(url: makeBucketImageURLString(path: imageURL))
            $0.layer.cornerRadius = 12
            $0.layer.masksToBounds = true
        }
        userNicknameLabel.applyWSSFont(.title2, with: nickname.truncateText(maxLength: 10))
        restTimeLabel.applyWSSFont(.body5, with: createdDate)
        modifiedLabel.isHidden = !isModified
    }
}
