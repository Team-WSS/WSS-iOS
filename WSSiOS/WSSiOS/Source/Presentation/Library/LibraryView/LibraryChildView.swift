//
//  LibraryChildView.swift
//  WSSiOS
//
//  Created by 신지원 on 1/14/24.
//

import UIKit

import SnapKit
import Then

final class LibraryChildView: UIView {
    
    //MARK: - Components
    
    let descriptionView = LibraryDescriptionView()
    let libraryDropdownView = LibraryListView()
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
            layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20)
            let cellWidth = (UIScreen.main.bounds.width - (6 * 2) - (20 * 2)) / 3
            layout.itemSize = CGSize(width: cellWidth, height: 240.0)
            
            $0.collectionViewLayout = layout
        }
        
        libraryEmptyView.isHidden = true
        libraryDropdownView.isHidden = true
    }
  
    private func setHierarchy() {
        self.addSubviews(descriptionView,
                         libraryCollectionView,
                         libraryEmptyView,
                         libraryDropdownView)
    }
    
    private func setLayout() {
        descriptionView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        libraryCollectionView.snp.makeConstraints() {
            $0.top.equalTo(descriptionView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(18)
        }
        
        libraryEmptyView.snp.makeConstraints() {
            $0.top.equalTo(descriptionView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
        
        libraryDropdownView.snp.makeConstraints() {
            $0.top.equalTo(descriptionView.snp.bottom)
            $0.trailing.equalToSuperview().inset(20)
            $0.width.equalTo(100)
            $0.height.equalTo(104)
        }
    }
}

