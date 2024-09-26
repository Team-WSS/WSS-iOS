//
//  NovelSelectedKeywordListView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 9/17/24.
//

import UIKit

import SnapKit
import Then

final class NovelSelectedKeywordListView: UIView {
    
    //MARK: - Components
    
    let selectedKeywordCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    //MARK: - Life Cycle
    
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
        selectedKeywordCollectionView.do {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.minimumInteritemSpacing = 6
            layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            
            $0.collectionViewLayout = layout
            $0.showsHorizontalScrollIndicator = false
            $0.tag = 1
        }
    }
    
    private func setHierarchy() {
        self.addSubview(selectedKeywordCollectionView)
    }
    
    private func setLayout() {
        selectedKeywordCollectionView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(18)
            $0.height.equalTo(35)
        }
    }
}
