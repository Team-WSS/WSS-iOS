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
        self.backgroundColor = .wssSecondary50
        
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
    }
    
    private func setHierarchy() {
        self.addSubview(addImageCollectionView)
    }
    
    private func setLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(100)
        }
        
        addImageCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
