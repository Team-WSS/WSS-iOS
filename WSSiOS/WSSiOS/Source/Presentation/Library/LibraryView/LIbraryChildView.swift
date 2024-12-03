//
//  View.swift
//  WSSiOS
//
//  Created by 신지원 on 1/14/24.
//

import UIKit

import SnapKit
import Then

final class LibraryChildView: UIView {
    
    //MARK: - Components
    
    lazy var libraryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    let libraryEmptyView = LibraryEmptyView()
    
    // MARK: - Life Cycle
    
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
        libraryCollectionView.do {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 20.0
            layout.minimumInteritemSpacing = 6
            layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
            layout.itemSize = CGSize(width: 108.0, height: 240.0)
            
            $0.collectionViewLayout = layout
            $0.showsVerticalScrollIndicator = false
        }
        
        libraryEmptyView.isHidden = true
    }
  
    private func setHierarchy() {
        self.addSubviews(libraryCollectionView,
                         libraryEmptyView)
    }
    
    private func setLayout() {
        libraryCollectionView.snp.makeConstraints() {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
        
        libraryEmptyView.snp.makeConstraints() {
            $0.edges.equalToSuperview()
        }
    }
}

