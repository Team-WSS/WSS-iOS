//
//  LibraryCollectionViewCell.swift
//  WSSiOS
//
//  Created by 신지원 on 1/14/24.
//

import UIKit

final class LibraryCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    static let identifier: String = "LibraryCollectionViewCell"
    
    //MARK: - UI Components
    
    public var novelImageView = UIImageView()
    public var novelTitleLabel = UILabel()
    public var novelAuthorLabel = UILabel()
    private let ratingStarImage = UIImageView(image: ImageLiterals.icon.Star.fill)
    public var novelRatingLabel = UILabel()
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierachy()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Set UI
    
    private func setUI() {
        
        novelImageView.do {
            $0.layer.cornerRadius = 10
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
    
    //MARK: - Set Hierachy
    
    private func setHierachy() {
        self.addSubviews(novelImageView,
                         novelTitleLabel,
                         novelAuthorLabel,
                         ratingStarImage,
                         novelRatingLabel)
    }
    
    //MARK: - Set Layout
    
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
}
