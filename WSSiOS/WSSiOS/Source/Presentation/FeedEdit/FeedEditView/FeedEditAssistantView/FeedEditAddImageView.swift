//
//  FeedEditAddImageView.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/13/25.
//

import UIKit

import SnapKit
import Then

final class FeedEditAddImageView: UIView {
    
    //MARK: - UI Components
    
    let addImageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    private let addImageCollectionViewLayout = UICollectionViewFlowLayout()
    let addImageCountLabel = UILabel()
    
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
        addImageCollectionViewLayout.do {
            $0.scrollDirection = .horizontal
            $0.itemSize = CGSize(width: 100, height: 100)
            $0.minimumLineSpacing = 10
            $0.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            addImageCollectionView.setCollectionViewLayout($0, animated: true)
        }
        
        addImageCollectionView.do {
            $0.showsHorizontalScrollIndicator = false
        }
        
        addImageCountLabel.do {
            $0.textColor = .wssGray200
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(addImageCollectionView,
                         addImageCountLabel)
    }
    
    private func setLayout() {
        addImageCollectionView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(100)
        }
        
        addImageCountLabel.snp.makeConstraints {
            $0.top.equalTo(addImageCollectionView.snp.bottom).offset(14)
            $0.leading.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
        }
    }
    
    //MARK: - Data
    
    func bindData(count: Int) {
        addImageCountLabel.do {
            $0.applyWSSFontPartialColor(.title2,
                                        with: String(count) + " / \(FeedEdit.imageMaxCount)",
                                        rangeText: String(count),
                                        color: .wssPrimary100)
        }
    }
}
