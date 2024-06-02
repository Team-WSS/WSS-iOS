//
//  NormalSearchResultView.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/27/24.
//

import UIKit

import SnapKit
import Then

final class NormalSearchResultView: UIView {
    
    //MARK: - Components
    let normalSearchCollectionView = UICollectionView(frame: .zero,
                                                      collectionViewLayout: UICollectionViewLayout())
    private let normalSearchCollectionViewLayout = UICollectionViewFlowLayout()
    
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
        normalSearchCollectionView.do {
            $0.showsVerticalScrollIndicator = false
        }
        
        normalSearchCollectionViewLayout.do {
            $0.scrollDirection = .vertical
            $0.minimumLineSpacing = 6
            $0.itemSize = CGSize(width: 335, height: 105)
            $0.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 40, right: 0)
            normalSearchCollectionView.setCollectionViewLayout($0, animated: false)
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(normalSearchCollectionView)
    }
    
    private func setLayout() {
        normalSearchCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
