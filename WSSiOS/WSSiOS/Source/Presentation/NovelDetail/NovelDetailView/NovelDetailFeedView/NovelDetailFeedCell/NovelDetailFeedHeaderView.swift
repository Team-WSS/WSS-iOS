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
    
    private let userImageView = UIImageView()
    private let userNicknameLabel = UILabel()
    private let dotImageView = UIImageView()
    private let createdDateLabel = UILabel()
    private let isModifiedLabel = UILabel()
    let dropdownImageView = UIImageView()
    
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
        
        dropdownImageView.do {
            $0.image = .icDropDownDot
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(userImageView,
                         userNicknameLabel,
                         dotImageView,
                         createdDateLabel,
                         isModifiedLabel,
                         dropdownImageView)
    }
    
    private func setLayout() {
        userImageView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.size.equalTo(36)
        }
        
        userNicknameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(userImageView.snp.trailing).offset(14)
        }
        
        dotImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(userNicknameLabel.snp.trailing).offset(6)
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
        
        dropdownImageView.snp.makeConstraints {
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
