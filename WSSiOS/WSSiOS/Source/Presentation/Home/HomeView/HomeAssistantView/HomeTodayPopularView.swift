//
//  HomeTodayPopularView.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 4/14/24.
//

import UIKit

import SnapKit
import Then

final class HomeTodayPopularView: UIView {
    
    //MARK: - UI Components
    
    private let titleLabel = UILabel()
    let todayPopularCollectionView = UICollectionView(frame: .zero,
                                                      collectionViewLayout: UICollectionViewLayout())
    private let todayPopularCollectionViewLayout = UICollectionViewFlowLayout()
    
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
            $0.font = .HeadLine1
            $0.textColor = .wssBlack
            $0.makeAttribute(with: StringLiterals.Home.Title.todayPopular)?
                .kerning(kerningPixel: -1.2)
                .applyAttribute()
        }
        
        todayPopularCollectionView.do {
            $0.showsHorizontalScrollIndicator = false
        }
        
        todayPopularCollectionViewLayout.do {
            $0.scrollDirection = .horizontal
            $0.minimumLineSpacing = 10
            $0.itemSize = CGSize(width: 292, height: 377)
            $0.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            todayPopularCollectionView.setCollectionViewLayout($0, animated: false)
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(titleLabel,
                         todayPopularCollectionView)
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
        
        todayPopularCollectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
