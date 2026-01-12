//
//  HomeTasteRecommendCollectionViewCell.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/9/24.
//

import UIKit

import SnapKit
import Then

final class HomeTasteRecommendCollectionViewCell: UICollectionViewCell {
    
    //MARK: - UI Components
    
    /// 소설 정보
    private var novelImageView = UIImageView()
    private var novelTitleLabel = UILabel()
    private var novelAuthorLabel = UILabel()
    
    /// 관심 정보
    private var likeImageView = UIImageView()
    private var likeCountLabel = UILabel()
    
    /// 평점 정보
    private var ratingImageView = UIImageView()
    private var ratingAverageLabel = UILabel()
    private var ratingCountLabel = UILabel()
    
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
        novelImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 14
            $0.layer.masksToBounds = true
        }
        
        novelTitleLabel.do {
            $0.textColor = .wssBlack
        }
        
        novelAuthorLabel.do {
            $0.textColor = .wssGray200
            $0.lineBreakMode = .byTruncatingTail
        }
        
        likeImageView.do {
            $0.image = .icHeart
            $0.contentMode = .scaleAspectFit
        }
        
        likeCountLabel.do {
            $0.textColor = .wssGray200
        }
        
        ratingImageView.do {
            $0.image = .icStar
            $0.contentMode = .scaleAspectFit
        }
        
        ratingAverageLabel.do {
            $0.textColor = .wssGray200
        }
        
        ratingCountLabel.do {
            $0.textColor = .wssGray200
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(novelImageView,
                         likeImageView,
                         likeCountLabel,
                         ratingImageView,
                         ratingAverageLabel,
                         ratingCountLabel,
                         novelTitleLabel,
                         novelAuthorLabel)
    }
    
    private func setLayout() {
        novelImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(241)
        }
        
        likeImageView.snp.makeConstraints {
            $0.size.equalTo(12)
            $0.leading.equalToSuperview()
            $0.top.equalTo(novelImageView.snp.bottom).offset(8.5)
        }
        
        likeCountLabel.snp.makeConstraints {
            $0.top.equalTo(novelImageView.snp.bottom).offset(6)
            $0.leading.equalTo(likeImageView.snp.trailing).offset(3)
        }
        
        ratingImageView.snp.makeConstraints {
            $0.size.equalTo(12)
            $0.top.equalTo(likeImageView.snp.top)
            $0.leading.equalTo(likeCountLabel.snp.trailing).offset(8)
        }
        ratingAverageLabel.snp.makeConstraints {
            $0.top.equalTo(likeCountLabel.snp.top)
            $0.leading.equalTo(ratingImageView.snp.trailing).offset(3)
        }
        
        ratingCountLabel.snp.makeConstraints {
            $0.top.equalTo(likeCountLabel.snp.top)
            $0.leading.equalTo(ratingAverageLabel.snp.trailing).offset(3)
        }
        
        novelTitleLabel.snp.makeConstraints {
            $0.top.equalTo(likeCountLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        novelAuthorLabel.snp.makeConstraints {
            $0.top.equalTo(novelTitleLabel.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func bindData(data: TasteRecommendNovel) {
        self.novelImageView.kfSetImage(url: data.novelImage)
        
        self.novelTitleLabel.do {
            $0.applyWSSFont(.label1, with: data.novelTitle)
            $0.lineBreakMode = .byTruncatingTail
            $0.numberOfLines = 1
        }
        self.novelAuthorLabel.do {
            $0.applyWSSFont(.body5, with: data.novelAuthor)
            $0.lineBreakMode = .byTruncatingTail
            $0.numberOfLines = 1
        }
        self.likeCountLabel.applyWSSFont(.body5, with: String(data.novelLikeCount))
        let roundedRating = round(data.novelRating * 10) / 10
        self.ratingAverageLabel.applyWSSFont(.body5, with: String(roundedRating))
        self.ratingCountLabel.applyWSSFont(.body5, with: "(\(data.novelRatingCount))")
    }
    
    func bindData(data: SearchNovel) {
        self.novelImageView.kfSetImage(url: data.novelImage)
        
        self.novelTitleLabel.do {
            $0.applyWSSFont(.label1, with: data.novelTitle)
            $0.lineBreakMode = .byTruncatingTail
            $0.numberOfLines = 1
        }
        self.novelAuthorLabel.do {
            $0.applyWSSFont(.body5, with: data.novelAuthor)
            $0.lineBreakMode = .byTruncatingTail
            $0.numberOfLines = 1
        }
        self.likeCountLabel.applyWSSFont(.body5, with: String(data.interestCount))
        self.ratingAverageLabel.applyWSSFont(.body5, with: String(format: "%.1f", data.novelRating))
        self.ratingCountLabel.applyWSSFont(.body5, with: "(\(data.novelRatingCount))")
    }
}
