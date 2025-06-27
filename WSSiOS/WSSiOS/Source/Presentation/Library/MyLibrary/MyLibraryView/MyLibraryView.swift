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
    let libraryCollectionView = MyLibraryCollectionView()
    let libraryTableView = MyLibraryTableView()
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
    
    func showEmptyLibraryView() {
        libraryEmptyView.isHidden = false
        libraryCollectionView.isHidden = true
        libraryTableView.isHidden = true
    }
    
    func showLibraryListView(selectedType: LayoutType) {
        libraryEmptyView.isHidden = true
        libraryCollectionView.isHidden = selectedType == .list
        libraryTableView.isHidden = selectedType == .grid
    }
}
