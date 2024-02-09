//
//  SearchResultView.swift
//  WSSiOS
//
//  Created by 최서연 on 1/6/24.
//

import UIKit

import SnapKit
import Then

final class SearchResultView: UIView {
    
    //MARK: - Components
    
    let searchCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
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
        searchCollectionView.do {
            $0.backgroundColor = .clear
            $0.showsVerticalScrollIndicator = false
            $0.keyboardDismissMode = .onDrag
        }
    }
    
    private func setHierarchy() {
        self.addSubview(searchCollectionView)
    }
    
    private func setLayout() {
        searchCollectionView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
}
