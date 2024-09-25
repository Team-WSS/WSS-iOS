//
//  NovelReviewKeywordView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 9/13/24.
//

import UIKit

import SnapKit
import Then

final class NovelReviewKeywordView: UIView {
    
    //MARK: - Components
    
    private let titleLabel = UILabel()
    let keywordSearchBarView = UIView()
    private let placeholderLabel = UILabel()
    private let searchImageView = UIImageView()
    let selectedKeywordCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
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
        
        titleLabel.do {
            $0.applyWSSFont(.body2, with: StringLiterals.NovelReview.Keyword.keyword)
            $0.textColor = .wssBlack
        }
        
        keywordSearchBarView.do {
            $0.backgroundColor = .wssGray50
            $0.layer.cornerRadius = 14
        }
        
        placeholderLabel.do {
            $0.applyWSSFont(.body4, with: StringLiterals.NovelReview.Keyword.placeholder)
            $0.textColor = .wssGray200
        }
        
        searchImageView.do {
            $0.image = .icSearch.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .wssGray300
        }
        
        selectedKeywordCollectionView.do {
            let layout = CenterAlignedCollectionViewFlowLayout()
            layout.minimumInteritemSpacing = 8
            layout.minimumLineSpacing = 8
            
            $0.collectionViewLayout = layout
            $0.isScrollEnabled = false
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(titleLabel,
                         keywordSearchBarView,
                         selectedKeywordCollectionView)
        keywordSearchBarView.addSubviews(placeholderLabel,
                                         searchImageView)
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(25)
        }
        
        keywordSearchBarView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(13)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(42)
            
            placeholderLabel.snp.makeConstraints {
                $0.center.equalToSuperview()
                $0.height.equalTo(42)
            }
            
            searchImageView.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.trailing.equalToSuperview().inset(15)
                $0.size.equalTo(25)
            }
        }
        
        selectedKeywordCollectionView.snp.makeConstraints {
            $0.top.equalTo(keywordSearchBarView.snp.bottom).offset(22)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(0)
            $0.bottom.equalToSuperview().inset(70)
        }
    }
    
    //MARK: - Custom Method
    
    func updateCollectionViewHeight(height: CGFloat) {
        selectedKeywordCollectionView.snp.updateConstraints {
            $0.height.equalTo(height)
        }
    }
}
