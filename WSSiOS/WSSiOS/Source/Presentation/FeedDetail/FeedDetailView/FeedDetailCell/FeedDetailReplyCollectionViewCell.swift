//
//  FeedDetailReplyCollectionViewCell.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 6/24/24.
//

import UIKit

import SnapKit
import Then

final class FeedDetailReplyCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Components
    
    private var userProfileImageView = UIImageView()
    private let userStackview = UIStackView()
    private let userNicknameLabel = UILabel()
    private let dotImageView = UIImageView()
    private let createdDateLabel = UILabel()
    private let isModifiedLabel = UILabel()
    private let replyContentLabel = UILabel()
    private let threeDotsButton = UIButton()
    
    //MARK: - Life Cycle
    
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
        userProfileImageView.do {
            $0.image = .imgLoadingThumbnail
            $0.layer.cornerRadius = 12
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
        }
        
        userStackview.do {
            $0.axis = .horizontal
            $0.spacing = 6
        }
        
        userNicknameLabel.do {
            $0.textColor = .wssBlack
        }
        
        dotImageView.do {
            $0.image = .icBlackDot
            $0.contentMode = .scaleAspectFit
        }
        
        createdDateLabel.do {
            $0.textColor = .wssBlack
        }
        
        isModifiedLabel.do {
            $0.textColor = .wssGray200
        }
        
        replyContentLabel.do {
            $0.textColor = .wssBlack
            $0.numberOfLines = 0
        }
        
        threeDotsButton.do {
            $0.setImage(.icThreedots.withRenderingMode(.alwaysOriginal).withTintColor(.wssGray100), for: .normal)
            $0.contentMode = .scaleAspectFit
        }
    }
    
    private func setHierarchy() {
        userStackview.addArrangedSubviews(userNicknameLabel,
                                          dotImageView,
                                          createdDateLabel,
                                          isModifiedLabel)
        self.addSubviews(userProfileImageView,
                         userStackview,
                         replyContentLabel,
                         threeDotsButton)
    }
    
    private func setLayout() {
        userProfileImageView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.size.equalTo(36)
            $0.top.equalToSuperview().inset(4.5)
        }
        
        userStackview.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(userProfileImageView.snp.trailing).offset(14)
        }
        
        replyContentLabel.snp.makeConstraints {
            $0.top.equalTo(userStackview.snp.bottom)
            $0.leading.equalTo(userStackview.snp.leading)
            $0.bottom.equalToSuperview()
        }
        
        threeDotsButton.snp.makeConstraints {
            $0.size.equalTo(18)
            $0.leading.equalTo(replyContentLabel.snp.trailing).offset(40)
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
    
    func bindData(data: Comment) {
        self.userProfileImageView.kfSetImage(url: data.userProfileImage)
        self.userNicknameLabel.applyWSSFont(.title2, with: data.userNickname)
        self.createdDateLabel.applyWSSFont(.body5, with: data.createdDate)
        if data.isModified {
            self.isModifiedLabel.applyWSSFont(.body5, with: StringLiterals.Feed.modifiedText)
        }
        self.replyContentLabel.do {
            $0.applyWSSFont(.body2, with: data.commentContent)
            $0.numberOfLines = 0
            $0.lineBreakStrategy = .hangulWordPriority
        }
    }
}
