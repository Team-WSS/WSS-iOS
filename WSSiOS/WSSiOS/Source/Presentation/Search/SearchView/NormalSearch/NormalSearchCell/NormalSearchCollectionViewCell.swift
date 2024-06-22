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
            $0.image = .icStar2
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
                         novelTitleLabel,
                         novelAuthorLabel,
                         likeImageView,
                         likeCountLabel,
                         ratingImageView,
                         ratingAverageLabel,
                         ratingCountLabel)
    }
    
    private func setLayout() {
        novelImageView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.width.equalTo(78)
            $0.height.equalTo(105)
        }
        
        likeCountLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(21)
            $0.leading.equalTo(likeImageView.snp.trailing).offset(3)
        }
        
        likeImageView.snp.makeConstraints {
            $0.size.equalTo(12)
            $0.centerY.equalTo(likeCountLabel.snp.centerY)
            $0.leading.equalTo(novelImageView.snp.trailing).offset(18)
        }
        
        ratingAverageLabel.snp.makeConstraints {
            $0.top.equalTo(likeCountLabel.snp.top)
            $0.leading.equalTo(ratingImageView.snp.trailing).offset(3)
        }
        
        ratingCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(ratingAverageLabel.snp.centerY)
            $0.leading.equalTo(ratingAverageLabel.snp.trailing).offset(2)
        }
        
        ratingImageView.snp.makeConstraints {
            $0.size.equalTo(12)
            $0.centerY.equalTo(ratingAverageLabel.snp.centerY)
            $0.leading.equalTo(likeCountLabel.snp.trailing).offset(8)
        }
    
        novelTitleLabel.snp.makeConstraints {
            $0.top.equalTo(likeCountLabel.snp.bottom).offset(4)
            $0.leading.equalTo(likeImageView.snp.leading)
            $0.trailing.equalToSuperview()
        }
        
        novelAuthorLabel.snp.makeConstraints {
            $0.top.equalTo(novelTitleLabel.snp.bottom).offset(4)
            $0.leading.equalTo(likeImageView.snp.leading)
            $0.trailing.equalToSuperview()
        }
    }
    
    func bindData(data: NormalSearchNovel) {
        self.novelImageView.image = UIImage(named: data.novelImage)
        self.novelTitleLabel.do {
            $0.applyWSSFont(.title3, with: data.novelTitle)
            $0.lineBreakMode = .byTruncatingTail
        }
        self.novelAuthorLabel.do {
            $0.applyWSSFont(.body5, with: data.novelAuthor)
            $0.lineBreakMode = .byTruncatingTail
        }
        self.likeCountLabel.fontBody5Attribute(with: String(data.interestCount))
        self.likeCountLabel.applyWSSFont(.body5, with: String(data.interestCount))
        self.ratingAverageLabel.applyWSSFont(.body5, with: String(data.ratingAverage))
        self.ratingCountLabel.do {
            $0.applyWSSFont(.body5, with: "(\(data.ratingCount))")
            $0.lineBreakMode = .byTruncatingTail
        }
    }
}
