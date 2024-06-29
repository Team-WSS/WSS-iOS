//
//  FeedCategoryView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 6/29/24.
//

import UIKit

import SnapKit
import Then

final class FeedCategoryView: UIView {
    
    //MARK: - Components
    
    private let categoryLabel = UILabel()
    private let essentialImageView = UIImageView()
    private let multipleSelectLabel = UILabel()
    let categoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
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
        
        categoryLabel.do {
            $0.applyWSSFont(.title2, with: "카테고리")
            $0.textColor = .wssBlack
        }
        
        essentialImageView.do {
            $0.image = .icEssential
            $0.contentMode = .scaleAspectFit
        }
        
        multipleSelectLabel.do {
            $0.applyWSSFont(.label1, with: "중복 선택 가능")
            $0.textColor = .Gray200
        }
        
        categoryCollectionView.do {
            let layout = LeftAlignedCollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 10
            layout.minimumInteritemSpacing = 6

            $0.collectionViewLayout = layout
            $0.isScrollEnabled = false
            $0.allowsMultipleSelection = true
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(categoryLabel,
                         essentialImageView,
                         multipleSelectLabel,
                         categoryCollectionView)
    }
    
    private func setLayout() {
        categoryLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
        
        essentialImageView.snp.makeConstraints {
            $0.top.equalTo(categoryLabel.snp.top).offset(2)
            $0.leading.equalTo(categoryLabel.snp.trailing).offset(2)
        }
        
        multipleSelectLabel.snp.makeConstraints {
            $0.top.equalTo(categoryLabel.snp.top).offset(3)
            $0.leading.equalTo(essentialImageView.snp.trailing).offset(6)
        }
        
        categoryCollectionView.snp.makeConstraints {
            $0.top.equalTo(categoryLabel.snp.bottom).offset(14)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(18)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(84)
        }
    }
}
