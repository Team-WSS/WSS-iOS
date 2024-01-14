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
    
    public var libraryCollectionView = UICollectionView()
    
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
            layout.minimumLineSpacing = 10.0
            layout.minimumInteritemSpacing = 3
            layout.itemSize = CGSize(width: 105.0,
                                     height: 243.0)
            
            $0.collectionViewLayout = layout
        }
    }
    
    //MARK: - set Hierachy
    
    private func setHierachy() {
        self.addSubview(libraryCollectionView)
    }
    
    //MARK: - set Layout
    
    private func setLayout() {
        libraryCollectionView.snp.makeConstraints() {
            $0.top.equalToSuperview().inset(100)
            $0.width.equalToSuperview()
            $0.bottom.equalToSuperview().inset(84)
        }
    }
}
