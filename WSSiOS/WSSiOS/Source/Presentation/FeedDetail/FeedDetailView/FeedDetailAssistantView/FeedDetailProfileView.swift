//
//  FeedDetailProfileView.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 6/23/24.
//

import UIKit

import Kingfisher
import SnapKit
import Then

final class FeedDetailProfileView: UIView {
    
    //MARK: - UI Components
    
    private let profileStackView = UIStackView()
    let userProfileImageView = UIImageView()
    private let userNicknameLabel = UILabel()
    private let blackDotImageView = UIImageView()
    private let createdDateLabel = UILabel()
    
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
        profileStackView.do {
            $0.axis = .horizontal
        }
        
        userProfileImageView.do {
            $0.image = .imgLoadingThumbnail
            $0.layer.cornerRadius = 12
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
        }
        
        userNicknameLabel.do {
            $0.textColor = .wssBlack
        }
        
        blackDotImageView.do {
            $0.image = .icBlackDot
            $0.contentMode = .scaleAspectFit
        }
        
        createdDateLabel.do {
            $0.textColor = .wssBlack
        }
    }
    
    private func setHierarchy() {
        self.addSubview(profileStackView)
        profileStackView.addArrangedSubviews(userProfileImageView,
                                             userNicknameLabel,
                                             blackDotImageView,
                                             createdDateLabel)
    }
    
    private func setLayout() {
        profileStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        userProfileImageView.snp.makeConstraints {
            $0.size.equalTo(36)
        }
        
        profileStackView.do {
            $0.setCustomSpacing(14, after: userProfileImageView)
            $0.setCustomSpacing(6, after: userNicknameLabel)
            $0.setCustomSpacing(6, after: blackDotImageView)
        }
    }
    
    func bindData(data: Feed) {
        userProfileImageView.kfSetImage(url: makeBucketImageURLString(path: data.userProfileImage))
        userNicknameLabel.applyWSSFont(.title2, with: data.userNickname)
        createdDateLabel.applyWSSFont(.body5, with: data.createdDate)
    }
}
