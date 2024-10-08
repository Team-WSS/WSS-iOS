//
//  FeedGenreView.swift
//  WSSiOS
//
//  Created by 신지원 on 5/14/24.
//

import UIKit

import SnapKit
import Then

final class FeedGenreView: UIView {
    
    //MARK: - Components
    
    lazy var feedCollectionView = UICollectionView(frame: .zero,
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
        
        feedCollectionView.do {
            let layout = UICollectionViewFlowLayout().then {
                $0.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                $0.minimumLineSpacing = 0
                $0.minimumInteritemSpacing = 0
                $0.scrollDirection = .vertical
            }
            
            $0.collectionViewLayout = layout
            $0.showsVerticalScrollIndicator = false
            $0.contentInsetAdjustmentBehavior = .always
        }
    }
    
    private func setHierarchy() {
        addSubview(feedCollectionView)
    }
    
    private func setLayout() {
        feedCollectionView.snp.makeConstraints() {
            $0.edges.equalToSuperview()
        }
    }
}
