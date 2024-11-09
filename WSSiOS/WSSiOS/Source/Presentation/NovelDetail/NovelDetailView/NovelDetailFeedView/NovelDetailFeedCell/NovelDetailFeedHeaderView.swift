//
//  NovelDetailFeedHeaderView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 9/27/24.
//

import UIKit

import SnapKit
import Then

final class NovelDetailFeedHeaderView: UIView {

    //MARK: - Components
    
    let profileView = UIStackView()
    private let userImageView = UIImageView()
    private let userNicknameLabel = UILabel()
    private let dotImageView = UIImageView()
    private let createdDateLabel = UILabel()
    private let isModifiedLabel = UILabel()
    let dropdownButton = UIButton()
    
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
        profileView.do {
            $0.axis = .horizontal
            $0.spacing = 14
            $0.alignment = .center
            $0.isUserInteractionEnabled = true
        }
        
        userImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 12
            $0.clipsToBounds = true
        }
        
        userNicknameLabel.do {
            $0.font = .Title2
            $0.textColor = .wssBlack
        }
        
        dotImageView.do {
            $0.image = .icDot
        }
        
        createdDateLabel.do {
            $0.font = .Body5
            $0.textColor = .wssBlack
        }
        
        isModifiedLabel.do {
            $0.applyWSSFont(.body5, with: StringLiterals.NovelDetail.Feed.Cell.isModified)
            $0.textColor = .wssGray200
        }
        
        dropdownButton.do {
            $0.setImage(.icDropDownDot, for: .normal)
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(profileView,
                         dotImageView,
                         createdDateLabel,
                         isModifiedLabel,
                         dropdownButton)
        profileView.addArrangedSubviews(userImageView,
                                     userNicknameLabel)
    }
    
    private func setLayout() {
        profileView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
        }
        
        userImageView.snp.makeConstraints {
            $0.size.equalTo(36)
        }
        
        dotImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(profileView.snp.trailing).offset(6)
            $0.size.equalTo(8)
        }
        
        createdDateLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(dotImageView.snp.trailing).offset(6)
        }
        
        isModifiedLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(createdDateLabel.snp.trailing).offset(6)
        }
        
        dropdownButton.snp.makeConstraints {
            $0.centerY.trailing.equalToSuperview()
            $0.size.equalTo(18)
        }
    }
    
    //MARK: - Data
    
    func bindData(avatarImage: String, nickname: String, createdDate: String, isModified: Bool) {
        userImageView.kfSetImage(url: makeBucketImageURLString(path: avatarImage))
        userNicknameLabel.applyWSSFont(.title2, with: nickname)
        createdDateLabel.applyWSSFont(.body5, with: createdDate)
        isModifiedLabel.isHidden = !isModified
    }
}
