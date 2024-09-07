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
            $0.applyWSSFont(.body3, with: "판소추천해요! 완결난지는 좀 되었는데 추천합니다. scp 같은 이상현상 물품을 모아놓은 창고를 관리하는 주인공입니다. 배경은 현대판타지이고 우리나라 세계관에가깝다구요! 정말 재미재미허니잼")
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
            $0.applyWSSFont(.body4, with: "234")
        }
        
        likeStackView.do {
            $0.axis = .horizontal
            $0.spacing = 4
            $0.alignment = .center
        }
        
        commentImageView.do {
            $0.image = .icComment
            $0.contentMode = .scaleAspectFit
        }
        
        commentCountLabel.do {
            $0.font = .Body4
            $0.textColor = .Gray200
            $0.applyWSSFont(.body4, with: "123")
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
        feedContentLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        likeStackView.snp.makeConstraints {
            $0.top.equalTo(feedContentLabel.snp.bottom).offset(16)
            $0.leading.bottom.equalToSuperview()
            $0.height.equalTo(19)
            
            likeImageView.snp.makeConstraints {
                $0.size.equalTo(16)
            }
        }
        
        commentStackView.snp.makeConstraints {
            $0.top.equalTo(likeStackView.snp.top)
            $0.leading.equalTo(likeStackView.snp.trailing).offset(18)
            $0.height.equalTo(19)
            $0.bottom.equalToSuperview()
            
            commentImageView.snp.makeConstraints {
                $0.size.equalTo(16)
            }
        }
    }
}
