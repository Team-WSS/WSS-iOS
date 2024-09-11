//
//  DetailSearchKeywordCategoryCollectionViewCell.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 9/10/24.
//

import UIKit

final class DetailSearchKeywordCategoryCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Components
    
    let keywordImageView = UIImageView()
    let keywordTitleLabel = UILabel()
    let keywordCollectionView = UICollectionView(frame: .zero,
                                                 collectionViewLayout: UICollectionViewLayout())
    private let dividerView = UIView()
    private let downArrowImageView = UIImageView()
    private let upArrowImageView = UIImageView()
    
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
            $0.layer.cornerRadius = 11
            $0.clipsToBounds = true
        }
        
        keywordImageView.do {
            $0.image = .icCategoryWorld
            $0.layer.cornerRadius = 10.67
            $0.contentMode = .scaleAspectFit
            $0.clipsToBounds = true
        }
        
        keywordTitleLabel.do {
            $0.textColor = .wssGray300
        }
        
        keywordCollectionView.do {
            let layout = LeftAlignedCollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 8
            layout.minimumInteritemSpacing = 6
            
            $0.collectionViewLayout = layout
            $0.isScrollEnabled = false
            $0.backgroundColor = .clear
        }
        
        dividerView.do {
            $0.backgroundColor = .wssGray50
        }
        
        downArrowImageView.do {
            $0.image = .icChevronDown
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(keywordImageView,
                         keywordTitleLabel,
                         keywordCollectionView,
                         dividerView,
                         downArrowImageView)
    }
    
    private func setLayout() {
        keywordImageView.snp.makeConstraints {
            $0.size.equalTo(32)
            $0.top.leading.equalToSuperview().inset(20)
        }
        
        keywordTitleLabel.snp.makeConstraints {
            $0.centerY.equalTo(keywordImageView.snp.centerY)
            $0.top.equalToSuperview().inset(25)
            $0.leading.equalTo(keywordImageView.snp.trailing).offset(8)
        }
        
        keywordCollectionView.snp.makeConstraints {
            $0.top.equalTo(keywordImageView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(100)
        }
        
        dividerView.snp.makeConstraints {
            $0.top.equalTo(keywordCollectionView.snp.bottom).offset(34)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        downArrowImageView.snp.makeConstraints {
            $0.size.equalTo(16)
            $0.top.equalTo(dividerView.snp.bottom).offset(13)
            $0.bottom.equalToSuperview().inset(14)
            $0.centerX.equalToSuperview()
        }
    }
    
    func updateCollectionViewHeight(height: CGFloat) {
        keywordCollectionView.snp.updateConstraints {
            $0.height.equalTo(height)
        }
    }
    
    func bindData(data: DetailSearchCategory) {
        //keywordImageView.kfSetImage(url: data.categoryImage)
        keywordTitleLabel.applyWSSFont(.title2, with: data.categoryName)
    }
}

