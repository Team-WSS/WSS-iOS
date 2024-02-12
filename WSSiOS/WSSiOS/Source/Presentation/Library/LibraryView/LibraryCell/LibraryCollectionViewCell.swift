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
    
    //MARK: - Properties
    
    static let identifier: String = "LibraryCollectionViewCell"
    
    //MARK: - Components
    
    private let novelImageView = UIImageView()
    private let novelTitleLabel = UILabel()
    private let novelAuthorLabel = UILabel()
    private let ratingStarImage = UIImageView(image: ImageLiterals.icon.Star.fill)
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
            $0.layer.cornerRadius = 10
            $0.clipsToBounds = true
        }
        
        novelTitleLabel.do {
            $0.font = .Body2
            $0.textColor = .Black
            $0.textAlignment = .left
            $0.numberOfLines = 2
        }
        
        novelAuthorLabel.do {
            $0.font = .Label1
            $0.textColor = .Gray200
            $0.textAlignment = .left
            $0.numberOfLines = 1
        }
        
        novelRatingLabel.do {
            $0.font = .Label1
            $0.textColor = .Black
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
    
    func bindData(_ data: UserNovelListDetail) {
        novelImageView.kfSetImage(url: data.userNovelImg)
        novelTitleLabel.text = data.userNovelTitle
        novelAuthorLabel.text = data.userNovelAuthor
        
        let novelRating = data.userNovelRating
        
        if novelRating == 0.0 {
            ratingStarImage.isHidden = true
            novelRatingLabel.isHidden = true
        }
        else {
            ratingStarImage.isHidden = false
            novelRatingLabel.isHidden = false
            novelRatingLabel.text = String(data.userNovelRating)
        }
    }
}
