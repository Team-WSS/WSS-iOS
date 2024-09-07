//
//  HomeRealtimePopularContentView.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/21/24.
//

import UIKit

import SnapKit
import Then

final class HomeRealtimePopularContentView: UIView {
    
    //MARK: - UI Components
    
    private let contentLabel = UILabel()
    private let likeImageView = UIImageView()
    private let likeCountLabel = UILabel()
    private let commentImageView = UIImageView()
    private let commentCountLabel = UILabel()
    
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
        contentLabel.do {
            $0.fontBody3Attribute(with: "판소추천해요! 완결난지는 좀 되었는데 추천합니다. scp 같은 이상현상 물품을 모아놓은 창고를 관리하는 주인공입니다. 배경은 현대판타지이고 우리나라 세계관에가깝다구용용용용요롤로로롤로로롤로로로ㅗ로롤로ㅗ로로로")
            $0.textColor = .wssBlack
            $0.lineBreakMode = .byTruncatingTail
            $0.lineBreakStrategy = .hangulWordPriority
            $0.numberOfLines = 3
        }
        
        likeImageView.do {
            $0.image = .icLikeDefault
        }
        
        likeCountLabel.do {
            $0.fontBody4Attribute(with: "123")
            $0.textColor = .wssGray200
        }
        
        commentImageView.do {
            $0.image = . icComment
        }
        
        commentCountLabel.do {
            $0.fontBody4Attribute(with: "234")
            $0.textColor = .wssGray200
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(contentLabel,
                         likeImageView,
                         likeCountLabel,
                         commentImageView,
                         commentCountLabel)
    }
    
    private func setLayout() {
        contentLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(63)
        }
        
        likeImageView.snp.makeConstraints {
            $0.size.equalTo(16)
            $0.top.equalTo(contentLabel.snp.bottom).offset(17.5)
            $0.leading.equalToSuperview()
        }
        
        likeCountLabel.snp.makeConstraints {
            $0.top.equalTo(likeImageView.snp.top)
            $0.leading.equalTo(likeImageView.snp.trailing).offset(4)
        }
        
        commentImageView.snp.makeConstraints {
            $0.size.equalTo(16)
            $0.top.equalTo(likeImageView.snp.top)
            $0.leading.equalTo(likeCountLabel.snp.trailing).offset(18)
        }
        
        commentCountLabel.snp.makeConstraints {
            $0.top.equalTo(likeImageView.snp.top)
            $0.leading.equalTo(commentImageView.snp.trailing).offset(4)
        }
    }
}
