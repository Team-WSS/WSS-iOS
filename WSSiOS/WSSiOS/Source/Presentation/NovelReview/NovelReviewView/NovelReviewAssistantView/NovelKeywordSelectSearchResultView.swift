//
//  NovelKeywordSelectSearchResultView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 9/17/24.
//

import UIKit

import SnapKit
import Then

final class NovelKeywordSelectSearchResultView: UIView {
    
    //MARK: - Components
    
    private let titleLabel = UILabel()
    let searchResultCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
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
        titleLabel.do {
            $0.applyWSSFont(.title3, with: StringLiterals.NovelReview.KeywordSearch.searchResult)
            $0.textColor = .wssGray300
        }
        
        searchResultCollectionView.do {
            let layout = LeftAlignedCollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 8
            layout.minimumInteritemSpacing = 6

            $0.collectionViewLayout = layout
            $0.isScrollEnabled = false
            $0.allowsMultipleSelection = true
            $0.tag = 2
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(titleLabel,
                         searchResultCollectionView)
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(28)
            $0.leading.equalToSuperview().inset(20)
        }
        
        searchResultCollectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(28)
            $0.height.equalTo(0)
        }
    }
    
    //MARK: - Custom Method
    
    func updateCollectionViewHeight(height: CGFloat) {
        searchResultCollectionView.snp.updateConstraints {
            $0.height.equalTo(height)
        }
    }
}
