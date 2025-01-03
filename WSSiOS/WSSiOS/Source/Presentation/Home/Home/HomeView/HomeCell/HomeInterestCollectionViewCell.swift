//
//  HomeInterestCollectionViewCell.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/2/24.
//

import UIKit

import SnapKit
import Then

final class HomeInterestCollectionViewCell: UICollectionViewCell {
    
    //MARK: - UI Components
    
    ///소설 정보
    private var novelBackgroundView = UIView()
    private var novelImageShadowView = UIView()
    private var novelImageView = UIImageView()
    private var novelTitleLabel = UILabel()
    
    /// 소설 평점 정보
    private var novelRatingStackView = UIStackView()
    private var starImageView = UIImageView()
    private var novelAverageRatingLabel = UILabel()
    private var novelRatingNumberLabel = UILabel()
    
    private var dividerLine = UIView()
    
    /// 소설에 대한 유저 정보 및 피드 글
    private var userProfileImageView = UIImageView()
    private var userNicknameLabel = UILabel()
    private var userFeedContentLabel = UILabel()
    
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
    
    //MARK: - UI
    
    private func setUI() {
        self.do {
            $0.contentView.layer.cornerRadius = 14
            $0.contentView.layer.masksToBounds = true
            $0.contentView.backgroundColor = .wssGray20
            
            $0.layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
            $0.layer.shadowOpacity = 1
            $0.layer.shadowOffset = CGSize(width: 0, height: 2)
            $0.layer.shadowRadius = 15
            $0.layer.masksToBounds = false
        }
        
        novelBackgroundView.do {
            $0.backgroundColor = .wssWhite
        }
        
        novelImageShadowView.do {
            $0.layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
            $0.layer.shadowOpacity = 1
            $0.layer.shadowOffset = CGSize(width: 0, height: 2)
            $0.layer.shadowRadius = 15
        }
        
        novelImageView.do {
            $0.layer.cornerRadius = 4
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
        }
        
        novelTitleLabel.do {
            $0.textColor = .wssBlack
        }
        
        novelRatingStackView.do {
            $0.axis = .horizontal
            $0.spacing = 3
            $0.backgroundColor = .wssGray50
            $0.layer.cornerRadius = 4
            $0.isLayoutMarginsRelativeArrangement = true
            $0.layoutMargins = UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10)
        }
        
        starImageView.do {
            $0.image = .icStar.withRenderingMode(.alwaysOriginal).withTintColor(.wssBlack)
            $0.contentMode = .scaleAspectFit
        }
        
        novelAverageRatingLabel.do {
            $0.textColor = .wssBlack
        }
        
        novelRatingNumberLabel.do {
            $0.textColor = .wssBlack
        }
        
        dividerLine.do {
            $0.backgroundColor = .wssGray50
        }
        
        userProfileImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
        }
        
        userNicknameLabel.do {
            $0.textColor = .wssBlack
        }
        
        userFeedContentLabel.do {
            $0.textColor = .wssGray300
        }
    }
    
    private func setHierarchy() {
        self.contentView.addSubviews(novelBackgroundView,
                                     dividerLine,
                                     userProfileImageView,
                                     userNicknameLabel,
                                     userFeedContentLabel)
        novelRatingStackView.addArrangedSubviews(starImageView,
                                                 novelAverageRatingLabel,
                                                 novelRatingNumberLabel)
        novelImageShadowView.addSubview(novelImageView)
        novelBackgroundView.addSubviews(novelImageShadowView,
                                        novelTitleLabel,
                                        novelRatingStackView)
    }
    
    private func setLayout() {
        novelBackgroundView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(118)
        }
        
        novelImageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(16)
            $0.width.equalTo(59)
            $0.height.equalTo(87)
        }
        
        novelRatingStackView.snp.makeConstraints {
            $0.top.equalTo(novelImageView.snp.top)
            $0.leading.equalTo(novelImageView.snp.trailing).offset(14)
        }
        
        novelTitleLabel.snp.makeConstraints {
            $0.top.equalTo(novelRatingStackView.snp.bottom).offset(10)
            $0.leading.equalTo(novelRatingStackView.snp.leading)
            $0.trailing.equalToSuperview().inset(31)
        }
        
        dividerLine.snp.makeConstraints {
            $0.bottom.equalTo(novelBackgroundView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        userProfileImageView.snp.makeConstraints {
            $0.top.equalTo(novelBackgroundView.snp.bottom).offset(18)
            $0.leading.equalToSuperview().inset(20)
            $0.size.equalTo(24)
        }
        
        userNicknameLabel.snp.makeConstraints {
            $0.top.equalTo(novelBackgroundView.snp.bottom).offset(19.5)
            $0.leading.equalTo(userProfileImageView.snp.trailing).offset(10)
        }
        
        userFeedContentLabel.snp.makeConstraints {
            $0.top.equalTo(userProfileImageView.snp.bottom).offset(10)
            $0.leading.equalTo(userProfileImageView.snp.leading)
            $0.trailing.equalToSuperview().inset(20)
        }
    }
    
    func bindData(data: InterestFeed) {
        self.novelImageView.kfSetImage(url: data.novelImage)
        self.novelTitleLabel.do {
            $0.applyWSSFont(.title3, with: data.novelTitle)
            $0.lineBreakMode = .byTruncatingTail
            $0.lineBreakStrategy = .hangulWordPriority
            $0.numberOfLines = 2
        }
        let roundedRating = round(data.novelRating * 10) / 10
        self.novelAverageRatingLabel.applyWSSFont(.body5, with: String(roundedRating))
        self.novelRatingNumberLabel.applyWSSFont(.body5, with: "(\(data.novelRatingCount))")
        
        self.userProfileImageView.kfSetImage(url: makeBucketImageURLString(path: data.userAvatarImage))
        self.userNicknameLabel.do {
            $0.applyWSSFont(.title3, with: "\(data.userNickname)\(StringLiterals.Home.Interest.feed)")
            $0.lineBreakMode = .byTruncatingTail
            $0.numberOfLines = 1
        }
        self.userFeedContentLabel.do {
            $0.applyWSSFont(.label1, with: data.userFeedContent)
            $0.lineBreakMode = .byTruncatingTail
            $0.lineBreakStrategy = .hangulWordPriority
            $0.numberOfLines = 3
        }
    }
}
