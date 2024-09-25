//
//  HomeRealTimePopularFeedView.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 4/21/24.
//

import UIKit

import SnapKit
import Then

final class HomeRealTimePopularFeedView: UIView {
    
    //MARK: - UI Components
    
    let feedContentLabel = UILabel()
    
    private let likeImageView = UIImageView()
    private let likeCountLabel = UILabel()
    private let likeStackView = UIStackView()
    
    private let commentImageView = UIImageView()
    private let commentCountLabel = UILabel()
    private let commentStackView = UIStackView()
    
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
        likeImageView.do {
            $0.image = .icLikeDefault.withRenderingMode(.alwaysOriginal).withTintColor(.wssGray200)
            $0.contentMode = .scaleAspectFit
        }
        
        likeCountLabel.do {
            $0.textColor = .Gray200
        }
        
        likeStackView.do {
            $0.axis = .horizontal
            $0.spacing = 4
            $0.alignment = .center
        }
        
        commentImageView.do {
            $0.image = .icComment.withRenderingMode(.alwaysOriginal).withTintColor(.wssGray200)
            $0.contentMode = .scaleAspectFit
        }
        
        commentCountLabel.do {
            $0.textColor = .Gray200
        }
        
        commentStackView.do {
            $0.axis = .horizontal
            $0.spacing = 4
            $0.alignment = .center
        }
    }
    
    private func setHierarchy() {
        likeStackView.addArrangedSubviews(likeImageView,
                                          likeCountLabel)
        commentStackView.addArrangedSubviews(commentImageView,
                                             commentCountLabel)
        self.addSubviews(feedContentLabel,
                         likeStackView,
                         commentStackView)
    }
    
    private func setLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(98)
        }
        
        feedContentLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        likeStackView.snp.makeConstraints {
            $0.leading.bottom.equalToSuperview()
            $0.height.equalTo(19)
            
            likeImageView.snp.makeConstraints {
                $0.size.equalTo(16)
            }
        }
        
        commentStackView.snp.makeConstraints {
            $0.bottom.equalTo(likeStackView.snp.bottom)
            $0.leading.equalTo(likeStackView.snp.trailing).offset(18)
            $0.height.equalTo(19)
            $0.bottom.equalToSuperview()
            
            commentImageView.snp.makeConstraints {
                $0.size.equalTo(16)
            }
        }
    }
    
    func bindData(data: RealtimePopularFeed) {
        feedContentLabel.do {
            if data.isSpoiler {
                $0.applyWSSFont(.body2, with: StringLiterals.Home.RealTimePopular.spoiler)
                $0.textColor = .wssSecondary100
            }
            else {
                $0.applyWSSFont(.body3, with: data.feedContent)
                $0.textColor = .wssBlack
            }
            $0.numberOfLines = 3
            $0.lineBreakMode = .byTruncatingTail
            $0.lineBreakStrategy = .hangulWordPriority
        }
        
        likeCountLabel.applyWSSFont(.body4, with: String(data.feedLikeCount))
        commentCountLabel.applyWSSFont(.body4, with: String(data.feedCommentCount))
    }
}
