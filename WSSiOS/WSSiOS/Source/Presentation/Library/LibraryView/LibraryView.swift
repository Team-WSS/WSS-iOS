//
//  View.swift
//  WSSiOS
//
//  Created by 신지원 on 1/14/24.
//

import UIKit

import SnapKit
import Then

class LibraryView: UIView {
    
    //MARK: - UI Components
    
    public var libraryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierachy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - set UI
    
    private func setUI() {
        libraryCollectionView.do {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 24.0
            layout.minimumInteritemSpacing = 3
            layout.sectionInset = UIEdgeInsets(top: 24, left: 0.1, bottom: 0, right: 0.1)
            layout.itemSize = CGSize(width: 105.0, height: 243.0)
            
            $0.collectionViewLayout = layout
            $0.showsVerticalScrollIndicator = false
        }
    }
    
    //MARK: - set Hierachy
    
    private func setHierachy() {
        self.addSubview(libraryCollectionView)
    }
    
    //MARK: - set Layout
    
    private func setLayout() {
        libraryCollectionView.snp.makeConstraints() {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.leading.equalTo(20)
            $0.bottom.equalToSuperview().inset(84)
        }
    }
}
