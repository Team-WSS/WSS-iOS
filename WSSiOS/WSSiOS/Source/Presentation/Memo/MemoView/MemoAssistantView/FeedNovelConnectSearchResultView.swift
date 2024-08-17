//
//  FeedNovelConnectSearchResultView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 8/17/24.
//

import UIKit

import SnapKit
import Then

final class FeedNovelConnectSearchResultView: UIView {
    
    //MARK: - Components
    
    let searchResultCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    let connectNovelButton = UIButton()
    let connectNovelLabel = UILabel()
    
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
        searchResultCollectionView.do {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 6
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 64, right: 0)
            layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 105)
            
            $0.collectionViewLayout = layout
        }
        
        connectNovelButton.do {
            $0.backgroundColor = .wssPrimary100
        }
        
        connectNovelLabel.do {
            $0.applyWSSFont(.title2, with: StringLiterals.Memo.Novel.connectSelectedNovel)
            $0.textColor = .white
            $0.isUserInteractionEnabled = false
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(searchResultCollectionView,
                         connectNovelButton)
        connectNovelButton.addSubview(connectNovelLabel)
    }
    
    private func setLayout() {
        searchResultCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        connectNovelButton.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(58)
        }
        
        connectNovelLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
