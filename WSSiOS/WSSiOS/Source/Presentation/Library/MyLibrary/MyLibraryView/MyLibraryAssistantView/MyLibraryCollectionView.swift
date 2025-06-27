//
//  MyLibraryCollectionView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 6/27/25.
//

import UIKit

import SnapKit
import Then

final class MyLibraryCollectionView: UIView {
    
    //MARK: - Components
    
    let libraryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
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
            layout.minimumLineSpacing = 18
            layout.minimumInteritemSpacing = 6
            layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
            let cellWidth = (UIScreen.main.bounds.width - (6 * 2) - (20 * 2)) / 3
            let cellHeight = cellWidth * 160 / 108 + 71
            layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
            
            $0.collectionViewLayout = layout
            $0.showsVerticalScrollIndicator = false
        }
    }
  
    private func setHierarchy() {
        self.addSubview(libraryCollectionView)
    }
    
    private func setLayout() {
        libraryCollectionView.snp.makeConstraints() {
            $0.edges.equalToSuperview()
        }
    }
}
