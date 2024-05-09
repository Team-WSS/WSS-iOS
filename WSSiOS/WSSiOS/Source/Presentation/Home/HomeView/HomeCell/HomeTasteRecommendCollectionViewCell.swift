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
    private var likeStackView = UIStackView()
    private var likeImageView = UIImageView()
    private var likeCountLabel = UILabel()
    
    /// 평점 정보
    private var ratingStackView = UIStackView()
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
            $0.font = .Label1
            $0.textColor = .wssBlack
        }
        
        novelAuthorLabel.do {
            $0.font = .Body5
            $0.textColor = .wssGray200
            $0.lineBreakMode = .byTruncatingTail
        }
        
        likeStackView.do {
            $0.axis = .horizontal
            $0.spacing = 3
        }
        
        likeImageView.do {
            $0.image = .icHeart
            $0.contentMode = .scaleAspectFit
        }
        
        likeCountLabel.do {
            $0.font = .Body5
            $0.textColor = .wssGray200
        }
        
        ratingStackView.do {
            $0.axis = .horizontal
            $0.spacing = 3
        }
        
        ratingImageView.do {
            $0.image = .icStar2
            $0.contentMode = .scaleAspectFit
        }
        
        ratingAverageLabel.do {
            $0.font = .Body5
            $0.textColor = .wssGray200
        }
        
        ratingCountLabel.do {
            $0.font = .Body5
            $0.textColor = .wssGray200
        }
    }
    
    private func setHierarchy() {
        likeStackView.addArrangedSubviews(likeImageView,
                                          likeCountLabel)
        ratingStackView.addArrangedSubviews(ratingImageView,
                                            ratingAverageLabel,
                                            ratingCountLabel)
        self.addSubviews(novelImageView,
                         likeStackView,
                         ratingStackView,
                         novelTitleLabel,
                         novelAuthorLabel)
    }
    
    private func setLayout() {
        self.snp.makeConstraints {
            $0.width.equalTo(163)
            $0.height.equalTo(319)
        }
        
        novelImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(241)
        }
        
        likeStackView.snp.makeConstraints {
            $0.top.equalTo(novelImageView.snp.bottom).offset(6)
            $0.leading.equalToSuperview()
        }
        
        ratingStackView.snp.makeConstraints {
            $0.top.equalTo(likeStackView.snp.top)
            $0.leading.equalTo(likeStackView.snp.trailing).offset(8)
        }
        
        novelTitleLabel.snp.makeConstraints {
            $0.top.equalTo(likeStackView.snp.bottom).offset(2)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview().inset(23)
        }
        
        novelAuthorLabel.snp.makeConstraints {
            $0.top.equalTo(novelTitleLabel.snp.bottom).offset(2)
            $0.leading.equalToSuperview()
        }
    }
    
    func bindData(data: TasteRecommendNovel) {
        self.novelImageView.image = UIImage(named: data.novelImage)
        self.novelTitleLabel.do {
            $0.makeAttribute(with: data.novelTitle)?
                .kerning(kerningPixel: -0.4)
                .lineSpacing(spacingPercentage: 145)
                .applyAttribute()
            $0.lineBreakMode = .byTruncatingTail
            $0.lineBreakStrategy = .hangulWordPriority
            $0.numberOfLines = 2
        }
        self.novelAuthorLabel.text = data.novelAuthor
        self.likeCountLabel.text = String(data.novelLikeCount)
        self.ratingAverageLabel.text = String(data.novelRating)
        self.ratingCountLabel.text = "(\(data.novelRatingCount))"
    }
}
