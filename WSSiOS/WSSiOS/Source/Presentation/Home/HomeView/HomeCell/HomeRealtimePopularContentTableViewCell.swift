//
//  HomeRealtimePopularContentTableViewCell.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/22/24.
//

import UIKit

import SnapKit
import Then

final class HomeRealtimePopularContentTableViewCell: UITableViewCell {
    
    //MARK: - UI Components
    
    private let contentLabel = UILabel()
    private let likeImageView = UIImageView()
    private let likeCountLabel = UILabel()
    private let commentImageView = UIImageView()
    private let commentCountLabel = UILabel()
    
    //MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
            $0.textColor = .wssBlack
        }
        
        likeImageView.do {
            $0.image = .icLikeDefault
        }
        
        likeCountLabel.do {
            $0.textColor = .wssGray200
        }
        
        commentImageView.do {
            $0.image = . icComment
        }
        
        commentCountLabel.do {
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
    
    func bindData(data: RealtimePopularFeed) {
        self.contentLabel.do {
            $0.fontBody3Attribute(with: data.feedContent)
            $0.lineBreakMode = .byTruncatingTail
            $0.lineBreakStrategy = .hangulWordPriority
            $0.numberOfLines = 3
        }
        
        self.likeCountLabel.fontBody4Attribute(with: String(data.feedLikeCount))
        self.commentCountLabel.fontBody4Attribute(with: String(data.feedCommentCount))
    }
}
