//
//  NovelDetailInfoReviewKeywordView.swift
//  WSSiOS
//
//  Created by YunhakLee on 8/16/24.
//

import UIKit

import SnapKit
import Then

final class NovelDetailInfoReviewKeywordView: UIView {
    
    //MARK: - UI Components
    
    let keywordCollectionView = UICollectionView(frame: .zero,
                                                      collectionViewLayout: UICollectionViewLayout())
    private let keywordCollectionViewLayout = UICollectionViewFlowLayout()
    
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
        keywordCollectionView.do {
            $0.showsHorizontalScrollIndicator = false
        }
        
        keywordCollectionViewLayout.do {
            $0.scrollDirection = .horizontal
            $0.minimumInteritemSpacing = 6
            $0.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            keywordCollectionView.setCollectionViewLayout($0,
                                                          animated: false)
        }
    }
    
    private func setHierarchy() {
        self.addSubview(keywordCollectionView)
    }
    
    private func setLayout() {
        keywordCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(44)
        }
    }
}
