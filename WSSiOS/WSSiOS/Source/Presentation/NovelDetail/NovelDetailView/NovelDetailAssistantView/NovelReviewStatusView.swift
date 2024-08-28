//
//  NovelReviewStatusView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 8/28/24.
//

import UIKit

import SnapKit
import Then

enum NovelReviewStatus: CaseIterable {
    case watching
    case watched
    case quit
}

final class NovelReviewStatusView: UIView {
    
    //MARK: - Components
    
    let statusCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
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
        statusCollectionView.do {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.minimumInteritemSpacing = 0
            layout.itemSize = CGSize(width: 105, height: 78)

            
            $0.collectionViewLayout = layout
            $0.isScrollEnabled = false
        }
    }
    
    private func setHierarchy() {
        self.addSubview(statusCollectionView)
    }
    
    private func setLayout() {
        statusCollectionView.snp.makeConstraints {
            $0.centerX.top.bottom.equalToSuperview()
            $0.width.equalTo(315)
            $0.height.equalTo(78)
        }
    }
}
