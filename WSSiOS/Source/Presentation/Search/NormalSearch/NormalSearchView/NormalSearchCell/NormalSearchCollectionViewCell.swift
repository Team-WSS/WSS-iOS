//
//  NormalSearchTableViewCell.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/27/24.
//

import UIKit

import SnapKit
import Then

final class NormalSearchCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Components
    ///소설 정보
    private let novelImageView = UIImageView()
    private let novelTitleLabel = UILabel()
    private let novelAuthorLabel = UILabel()
    
    /// 좋아요 정보
    private let likeImageView = UIImageView()
    private let likeCountLabel = UILabel()
    
    /// 평점 정보
    private let ratingImageView = UIImageView()
    private let ratingAverageLabel = UILabel()
    private let ratingCountLabel = UILabel()
    
    private let reactStackView = UIStackView()
    private let stackView = UIStackView()
    
    //MARK: - Life Cycle
    
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
        self.do {
            $0.backgroundColor = .wssWhite
        }
        
        novelImageView.do {
            $0.image = .imgLoadingThumbnail
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
        }
        
        novelTitleLabel.do {
            $0.textColor = .wssBlack
        }
        
        novelAuthorLabel.do {
            $0.textColor = .wssGray200
        }
        
        likeImageView.do {
            $0.image = .icHeart
        }
        
        likeCountLabel.do {
            $0.textColor = .wssGray200
        }
        
        ratingImageView.do {
            $0.image = .icStar
        }
        
        ratingAverageLabel.do {
            $0.textColor = .wssGray200
        }
        
        ratingCountLabel.do {
            $0.textColor = .wssGray200
        }
        
        reactStackView.do {
            $0.axis = .horizontal
        }
        
        stackView.do {
            $0.axis = .vertical
            $0.spacing = 4
            $0.alignment = .leading
        }
    }
    
    private func setHierarchy() {
        reactStackView.addArrangedSubviews(likeImageView,
                                           likeCountLabel,
                                           ratingImageView,
                                           ratingAverageLabel,
                                           ratingCountLabel)
        stackView.addArrangedSubviews(reactStackView,
                                      novelTitleLabel,
                                      novelAuthorLabel)
        self.addSubviews(novelImageView, stackView)
    }
    
    private func setLayout() {
        novelImageView.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            $0.width.equalTo(78)
            $0.height.equalTo(105)
        }
        
        likeImageView.snp.makeConstraints {
            $0.size.equalTo(12)
        }
        
        ratingImageView.snp.makeConstraints {
            $0.size.equalTo(12)
        }
        
        reactStackView.do {
            $0.setCustomSpacing(3, after: likeImageView)
            $0.setCustomSpacing(8, after: likeCountLabel)
            $0.setCustomSpacing(3, after: ratingImageView)
            $0.setCustomSpacing(2, after: ratingAverageLabel)
        }
        
        stackView.snp.makeConstraints {
            $0.leading.equalTo(novelImageView.snp.trailing).offset(18)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
    }
    
    func bindData(data: SearchNovel) {
        self.novelImageView.kfSetImage(url: data.novelImage)
        
        self.novelTitleLabel.do {
            $0.applyWSSFont(.title3, with: data.novelTitle)
            $0.lineBreakMode = .byTruncatingTail
            $0.numberOfLines = 2
        }
        self.novelAuthorLabel.do {
            $0.applyWSSFont(.body5, with: data.novelAuthor)
            $0.lineBreakMode = .byTruncatingTail
        }
        self.likeCountLabel.applyWSSFont(.body5, with: String(data.interestCount))
        self.ratingAverageLabel.applyWSSFont(.body5, with: String(data.novelRating))
        self.ratingCountLabel.do {
            $0.applyWSSFont(.body5, with: "(\(data.novelRatingCount))")
            $0.lineBreakMode = .byTruncatingTail
        }
    }
}
