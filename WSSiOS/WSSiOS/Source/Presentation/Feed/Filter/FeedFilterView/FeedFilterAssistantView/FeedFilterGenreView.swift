//
//  FeedFilterGenreView.swift
//  WSSiOS
//
//  Created by YunhakLee on 5/26/25.
//

import UIKit

import SnapKit
import Then

final class FeedFilterGenreView: UIView {
    
    //MARK: - UI Components
    
    private let titleLabel = UILabel()
    let genreCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
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
    
    private func setUI() {
        titleLabel.do {
            $0.applyWSSFont(.title2, with: StringLiterals.Feed.Filter.genre)
            $0.textColor = .wssBlack
        }
        
        genreCollectionView.do {
            let layout = LeftAlignedCollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 12
            layout.minimumInteritemSpacing = 6
            
            $0.collectionViewLayout = layout
            $0.isScrollEnabled = false
            $0.backgroundColor = .clear
            $0.allowsMultipleSelection = true
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(titleLabel,
                         genreCollectionView)
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().inset(20)
        }
        
        genreCollectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(86)
            $0.bottom.equalToSuperview()
        }
    }
}
