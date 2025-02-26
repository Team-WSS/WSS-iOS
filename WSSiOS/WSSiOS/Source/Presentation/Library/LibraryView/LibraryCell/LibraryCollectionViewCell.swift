//
//  LibraryCollectionViewCell.swift
//  WSSiOS
//
//  Created by 신지원 on 1/14/24.
//

import UIKit

import SnapKit
import Then

final class LibraryCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Components
    
    private let novelImageView = UIImageView()
    private let novelTitleLabel = UILabel()
    private let novelAuthorLabel = UILabel()
    private let ratingStarImage = UIImageView(image: .icStarFill)
    private let novelRatingLabel = UILabel()
    
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
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
        }
        
        novelTitleLabel.do {
            $0.textColor = .wssBlack
            $0.textAlignment = .left
            $0.numberOfLines = 2
            $0.lineBreakMode = .byTruncatingTail
        }
        
        novelAuthorLabel.do {
            $0.textColor = .wssGray200
            $0.textAlignment = .left
            $0.numberOfLines = 1
            $0.lineBreakMode = .byTruncatingTail
        }
        
        novelRatingLabel.do {
            $0.textColor = .wssGray200
        }
    }

    private func setHierarchy() {
        self.addSubviews(novelImageView,
                         novelTitleLabel,
                         novelAuthorLabel,
                         ratingStarImage,
                         novelRatingLabel)
    }
    
    private func setLayout() {
        novelImageView.snp.makeConstraints() {
            $0.width.equalToSuperview()
            $0.height.equalTo(155)
        }
        
        novelTitleLabel.snp.makeConstraints() {
            $0.top.equalTo(novelImageView.snp.bottom).offset(10)
            $0.width.equalToSuperview()
        }
        
        novelAuthorLabel.snp.makeConstraints() {
            $0.top.equalTo(novelTitleLabel.snp.bottom)
            $0.width.equalToSuperview()
        }
        
        ratingStarImage.snp.makeConstraints() {
            $0.top.equalTo(novelAuthorLabel.snp.bottom).offset(6.5)
            $0.leading.equalToSuperview()
            $0.size.equalTo(10)
        }
        
        novelRatingLabel.snp.makeConstraints() {
            $0.centerY.equalTo(ratingStarImage.snp.centerY)
            $0.leading.equalTo(ratingStarImage.snp.trailing).offset(5)
        }
    }
    
    //MARK: - Data
    
    func bindData(_ data: UserNovel) {
        novelImageView.kfSetImage(url: data.novelImage)
        novelTitleLabel.applyWSSFont(.body4, with: data.title)
        novelAuthorLabel.applyWSSFont(.body5, with: data.author)
        
        let novelRating = data.novelRating
        
        if novelRating == 0.0 {
            ratingStarImage.isHidden = true
            novelRatingLabel.isHidden = true
        }
        else {
            ratingStarImage.isHidden = false
            novelRatingLabel.isHidden = false
            novelRatingLabel.applyWSSFont(.body5, with: String(data.novelRating))
        }
    }
}
