//
//  FeedPageBar.swift
//  WSSiOS
//
//  Created by 신지원 on 5/19/24.
//

import UIKit

import SnapKit
import Then

final class FeedPageBar: UIView {
    
    //MARK: - Components
    
    lazy var feedPageBarCollectionView = UICollectionView(frame: .zero,
                                                          collectionViewLayout: UICollectionViewLayout())
    
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
        
        feedPageBarCollectionView.do {
            let layout = UICollectionViewFlowLayout().then {
                $0.scrollDirection = .horizontal
                $0.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
                $0.minimumLineSpacing = 6
            }
            
            $0.collectionViewLayout = layout
            $0.showsHorizontalScrollIndicator = false
        }
    }
    
    private func setHierarchy() {
        addSubview(feedPageBarCollectionView)
    }
    
    private func setLayout() {
        feedPageBarCollectionView.snp.makeConstraints() {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
    }
}
