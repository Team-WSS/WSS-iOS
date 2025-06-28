//
//  MyLibraryView.swift
//  WSSiOS
//
//  Created by YunhakLee on 6/26/25.
//

import UIKit

import SnapKit
import Then

final class MyLibraryView: UIView {
    
    //MARK: - Components
    
    private let navigationView = MyLibraryNavigationView()
    let headerView = MyLibraryHeaderView()
    let libraryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    let libraryTableView = UITableView(frame: .zero, style: .plain)
    let libraryEmptyView = MyLibraryEmptyView()
    
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
        self.backgroundColor = .wssWhite
        
        libraryTableView.do {
            $0.showsVerticalScrollIndicator = false
            $0.separatorStyle = .none
            $0.estimatedRowHeight = 220
        }
        
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
        self.addSubviews(navigationView,
                         headerView,
                         libraryCollectionView,
                         libraryTableView,
                         libraryEmptyView)
    }
    
    private func setLayout() {
        navigationView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.horizontalEdges.equalToSuperview()
        }
        
        headerView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
        }
        
        libraryCollectionView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        libraryTableView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        libraryEmptyView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    func showEmptyLibraryView(isShowing: Bool) {
        libraryEmptyView.isHidden = !isShowing
    }
    
    func showLibraryListView(selectedType: LayoutType) {
        libraryCollectionView.isHidden = selectedType == .list
        libraryTableView.isHidden = selectedType == .grid
    }
}
