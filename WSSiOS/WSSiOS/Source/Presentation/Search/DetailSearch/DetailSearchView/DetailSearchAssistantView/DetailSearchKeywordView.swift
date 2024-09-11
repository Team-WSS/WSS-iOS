//
//  DetailSearchKeywordView.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 7/21/24.
//

import UIKit

import SnapKit
import Then

final class DetailSearchKeywordView: UIView {
    
    //MARK: - UI Components
    
    let searchBarView = DetailSearchKeywordSearchBarView()
    let categoryCollectionView = UICollectionView(frame: .zero,
                                                  collectionViewLayout: UICollectionViewLayout())
    private let categoryCollectionViewFlowLayout = UICollectionViewFlowLayout()
    
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
    
    private func setUI() {
        categoryCollectionView.do {
            $0.backgroundColor = .wssGray50
            $0.showsVerticalScrollIndicator = false
        }
        
        categoryCollectionViewFlowLayout.do {
            $0.scrollDirection = .vertical
            $0.minimumLineSpacing = 14
            $0.itemSize = CGSize(width: (UIScreen.main.bounds.width - 24), height: 224)
            $0.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 100, right: 0)
            categoryCollectionView.setCollectionViewLayout($0, animated: false)
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(searchBarView,
                         categoryCollectionView)
    }
    
    private func setLayout() {
        searchBarView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        categoryCollectionView.snp.makeConstraints {
            $0.top.equalTo(searchBarView.snp.bottom).offset(25)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
    }
}
