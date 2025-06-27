//
//  MyLibraryCollectionViewCell.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 6/27/25.
//

import UIKit

import SnapKit
import Then

final class MyLibraryCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Components
    
    private let novelImageView = UIImageView()
    private let readStatusTagView = MyLibraryReadStatusTagView()
    private let interestImageView = UIImageView()
    private let stackView = UIStackView()
    private let novelTitleLabel = UILabel()
    private let starStackView = UIStackView()
    private var starImageViews: [UIImageView] = []
    private let dateLabel = UILabel()
    
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
        novelImageView.do {
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
        }
        
        readStatusTagView.do {
            $0.layer.cornerRadius = 4
            $0.clipsToBounds = true
        }
        
        interestImageView.do {
            $0.image = .icNovelInterest
        }
        
        stackView.do {
            $0.axis = .vertical
            $0.alignment = .leading
        }
        
        novelTitleLabel.do {
            $0.textColor = .wssBlack
            $0.textAlignment = .left
            $0.numberOfLines = 2
            $0.lineBreakMode = .byTruncatingTail
        }
        
        starStackView.do {
            $0.axis = .horizontal
            $0.spacing = 2
        }
        
        dateLabel.do {
            $0.textColor = .wssGray200
        }
    }
    
    private func setHierarchy() {
        contentView.addSubviews(novelImageView,
                                readStatusTagView,
                                interestImageView,
                                stackView)
        stackView.addArrangedSubviews(novelTitleLabel,
                                      starStackView,
                                      dateLabel)
        
        for _ in 0..<5 {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.image = .icStarEmpty
            imageView.snp.makeConstraints {
                $0.size.equalTo(9)
            }
            starStackView.addArrangedSubview(imageView)
            starImageViews.append(imageView)
        }
    }
    
    private func setLayout() {
        novelImageView.snp.makeConstraints() {
            let imageWidth = (UIScreen.main.bounds.width - (6 * 2) - (20 * 2)) / 3
            let imageHeight = imageWidth * 160 / 108
            
            $0.top.leading.trailing.equalToSuperview()
            $0.width.equalTo(imageWidth)
            $0.height.equalTo(imageHeight)
        }
        
        readStatusTagView.snp.makeConstraints() {
            $0.left.equalTo(novelImageView.snp.left).offset(6)
            $0.bottom.equalTo(novelImageView.snp.bottom).offset(-7)
            $0.width.equalTo(49)
            $0.height.equalTo(18)
        }
        
        interestImageView.snp.makeConstraints() {
            $0.right.equalTo(novelImageView.snp.right).offset(-9.5)
            $0.bottom.equalTo(novelImageView.snp.bottom).offset(-9.5)
        }
        
        stackView.snp.makeConstraints() {
            $0.top.equalTo(novelImageView.snp.bottom).offset(6)
            $0.width.equalToSuperview()
            
            stackView.setCustomSpacing(2, after: novelTitleLabel)
            stackView.setCustomSpacing(6, after: starStackView)
        }
    }
    
    //MARK: - Data
    
    func bindData(_ data: MyLibraryEntity) {
        novelImageView.kfSetImage(url: data.novelImage)
        if let readStatus = data.readStatus {
            readStatusTagView.isHidden = false
            readStatusTagView.bindData(readStatus: readStatus)
        } else {
            readStatusTagView.isHidden = true
        }
        interestImageView.isHidden = !data.isInterest
        novelTitleLabel.applyWSSFont(.body4, with: data.title)
        if data.userNovelRating > 0.0 {
            starStackView.isHidden = false
            setRating(data.userNovelRating)
        } else {
            starStackView.isHidden = true
        }
        
        if let startDate = data.startDate, let endDate = data.endDate {
            dateLabel.isHidden = false
            dateLabel.applyWSSFont(.label2, with: "\(startDate) ~ \(endDate)")
        } else if let startDate = data.startDate {
            dateLabel.isHidden = false
            dateLabel.applyWSSFont(.label2, with: startDate)
        } else if let endDate = data.endDate {
            dateLabel.isHidden = false
            dateLabel.applyWSSFont(.label2, with: endDate)
        } else {
            dateLabel.isHidden = true
        }
    }
    
    func setRating(_ rating: Float) {
        for (index, imageView) in starImageViews.enumerated() {
            let starValue = Float(index) + 1
            
            if rating >= starValue {
                imageView.image = .icStarFill
            } else if rating >= starValue - 0.5 {
                imageView.image = .icStarHalf
            } else {
                imageView.image = .icStarEmpty
            }
        }
    }
}
