//
//  NovelReviewStatusCollectionViewCell.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 8/28/24.
//

import UIKit

import SnapKit
import Then

final class NovelReviewStatusCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    override var isSelected: Bool {
        didSet {
            self.updateTintColor(isSelected: isSelected)
        }
    }
    
    //MARK: - Components
    
    private let statusImageView = UIImageView()
    private let titleLabel = UILabel()
    
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
        statusImageView.do {
            $0.contentMode = .scaleAspectFit
            $0.tintColor = .wssGray200
        }
        
        titleLabel.do {
            $0.textColor = .wssGray200
        }
    }
    
    private func setHierarchy() {
        contentView.addSubviews(statusImageView,
                                titleLabel)
    }
    
    private func setLayout() {
        statusImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.leading.trailing.equalToSuperview().inset(34.5)
            $0.size.equalTo(36)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(statusImageView.snp.bottom).offset(5)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(10)
        }
    }
    
    //MARK: - Data
    
    func bindData(status: NovelReviewStatus) {
        switch status {
        case .watching:
            statusImageView.do {
                $0.image = UIImage(resource: .icNovelReviewWatching).withRenderingMode(.alwaysTemplate)
            }
            
            titleLabel.do {
                $0.applyWSSFont(.body5, with: StringLiterals.NovelReview.Status.watching)
            }
        case .watched:
            statusImageView.do {
                $0.image = UIImage(resource: .icNovelReviewWatched).withRenderingMode(.alwaysTemplate)
            }
            
            titleLabel.do {
                $0.applyWSSFont(.body5, with: StringLiterals.NovelReview.Status.watched)
            }
        case .quit:
            statusImageView.do {
                $0.image = UIImage(resource: .icNovelReviewQuit).withRenderingMode(.alwaysTemplate)
            }
            
            titleLabel.do {
                $0.applyWSSFont(.body5, with: StringLiterals.NovelReview.Status.quit)
            }
        }
    }
    
    //MARK: - Custom Method
    
    private func updateTintColor(isSelected: Bool) {
        statusImageView.do {
            $0.tintColor = isSelected ? .wssPrimary100 : .wssGray200
        }
        
        titleLabel.do {
            $0.textColor = isSelected ? .wssPrimary100 : .wssGray200
        }
    }
}
