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
    
    private let feedContentLabel = UILabel()
    
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
        feedContentLabel.do {
            $0.font = .Body3
            $0.textColor = .wssBlack
            $0.makeAttribute(with: "판소추천해요! 완결난지는 좀 되었는데 추천합니다. scp 같은 이상현상 물품을 모아놓은 창고를 관리하는 주인공입니다. 배경은 현대판타지이고 우리나라 세계관에가깝다구요! 정말 재미재미허니잼")?
                .kerning(kerningPixel: -0.4)
                .lineSpacing(spacingPercentage: 150)
                .applyAttribute()
            $0.numberOfLines = 3
            $0.lineBreakMode = .byTruncatingTail
            $0.lineBreakStrategy = .hangulWordPriority
        }
        
        likeImageView.do {
            $0.image = .icLikeDefault
            $0.contentMode = .scaleAspectFit
        }
        
        likeCountLabel.do {
            $0.font = .Body4
            $0.textColor = .Gray200
            $0.makeAttribute(with: "234")?
                .kerning(kerningPixel: -0.4)
                .lineSpacing(spacingPercentage: 145)
                .applyAttribute()
        }
        
        likeStackView.do {
            $0.axis = .horizontal
            $0.spacing = 4
        }
        
        commentImageView.do {
            $0.image = .icComment
            $0.contentMode = .scaleAspectFit
        }
        
        commentCountLabel.do {
            $0.font = .Body4
            $0.textColor = .Gray200
            $0.makeAttribute(with: "123")?
                .kerning(kerningPixel: -0.4)
                .lineSpacing(spacingPercentage: 145)
                .applyAttribute()
        }
        
        commentStackView.do {
            $0.axis = .horizontal
            $0.spacing = 4
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
        feedContentLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        likeStackView.snp.makeConstraints {
            $0.top.equalTo(feedContentLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview()
            $0.height.equalTo(19)
        }
        
        commentStackView.snp.makeConstraints {
            $0.top.equalTo(likeStackView.snp.top)
            $0.leading.equalTo(likeStackView.snp.trailing).offset(18)
            $0.height.equalTo(19)
        }
    }
}
