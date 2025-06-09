//
//  FeedDetailNovelView.swift
//  WSSiOS
//
//  Created by 신지원 on 5/29/25.
//

import UIKit

import SnapKit
import Then

final class FeedDetailNovelView: UIView {
    
    //MARK: - Components
    
    private let contentView = UIView()
    private let novelImageView = UIImageView()
    private let novelMarkImageView = UIImageView()
    
    private let novelInfoContentView = UIView()
    private let novelTitleLabel = UILabel()
    private let novelStarView = FeedDetailNovelStarView()
    private let novelSummaryLabel = UILabel()
    
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
        contentView.do {
            $0.backgroundColor = .wssWhite
            $0.layer.cornerRadius = 14
            $0.layer.borderColor = UIColor.wssGray80.cgColor
            $0.layer.borderWidth = 1
            $0.clipsToBounds = true
        }
        
        [novelImageView,
         novelMarkImageView].forEach {
            $0.contentMode = .scaleAspectFill
        }
        
        novelTitleLabel.do {
            $0.textColor = .wssBlack
            $0.numberOfLines = 2
            $0.lineBreakMode = .byTruncatingTail
            $0.lineBreakStrategy = .hangulWordPriority
        }
        
        novelSummaryLabel.do {
            $0.textColor = .wssGray300
            $0.numberOfLines = 2
        }
    }
    
    private func setHierarchy() {
        addSubview(contentView)
        contentView.addSubviews(novelImageView,
                                novelMarkImageView,
                                novelInfoContentView)
        novelInfoContentView.addSubviews(novelTitleLabel,
                                         novelStarView,
                                         novelSummaryLabel)
    }
    
    private func setLayout() {
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(123)
        }
        
        novelImageView.snp.makeConstraints {
            $0.verticalEdges.leading.equalToSuperview()
            $0.width.equalTo(86)
        }
        
        novelMarkImageView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.trailing.equalTo(novelImageView)
            $0.size.equalTo(50)
        }
        
        novelInfoContentView.snp.makeConstraints {
            $0.centerY.trailing.equalToSuperview()
            $0.leading.equalTo(novelImageView.snp.trailing).offset(20)
        }
        
        novelTitleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.trailing.equalToSuperview().inset(37)
        }
    
        novelStarView.snp.makeConstraints {
            $0.top.equalTo(novelTitleLabel.snp.bottom).offset(2)
            $0.leading.equalToSuperview()
        }
        
        novelSummaryLabel.snp.makeConstraints {
            $0.top.equalTo(novelStarView.snp.bottom).offset(12)
            $0.leading.bottom.equalToSuperview()
            $0.trailing.equalToSuperview().inset(37)
        }
    }
    
    //MARK: - Data
    
    func bindData(novelData: FeedDetailNovelEntity) {
        novelImageView.kfSetImage(url: novelData.novelThumbnailURL)
        novelMarkImageView.image = novelData.novelGenreImage
        novelTitleLabel.do {
            $0.applyWSSFont(.title2, with: novelData.novelTitle)
            $0.lineBreakMode = .byTruncatingTail
            $0.lineBreakStrategy = .hangulWordPriority
        }
        novelStarView.bindData(hasFeedAuthor: novelData.hasFeedAuthorRating,
                               feedAuthorData: novelData.feedAuthorData,
                               totalRating: novelData.novelRating)
        novelSummaryLabel.do {
            $0.applyWSSFont(.body5, with: novelData.novelDescription)
            $0.lineBreakMode = .byTruncatingTail
            $0.lineBreakStrategy = .hangulWordPriority
        }
    }
}
