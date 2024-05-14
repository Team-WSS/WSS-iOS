//
//  FeedView.swift
//  WSSiOS
//
//  Created by 신지원 on 5/14/24.
//

import UIKit

import SnapKit
import Then

final class FeedView: UIView {
    
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
        feedCollectionView.do {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            $0.collectionViewLayout = layout
            $0.showsVerticalScrollIndicator = false
        }
    }
    
    private func setHierarchy() {
        self.addSubview(feedCollectionView)
    }
    
    private func setLayout() {
        feedCollectionView.snp.makeConstraints() {
            //TODO: - top 추후 수정
            $0.top.equalToSuperview()
            $0.edges.equalToSuperview()
        }
    }
}
