//
//  HomeRealtimePopularView.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 4/20/24.
//

import UIKit

import SnapKit
import Then

final class HomeRealtimePopularView: UIView {
    
    //MARK: - UI Components
    
    private var titleLogoImageView = UIImageView()
    private var titleLabel = UILabel()
    private var titleStackView = UIStackView()
    
    let realtimePopularCollectionView = UICollectionView(frame: .zero,
                                                         collectionViewLayout: UICollectionViewLayout())
    private let realtimePopularCollectionViewLayout = UICollectionViewFlowLayout()
    private var scrollView = UIScrollView()
    
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
        titleLogoImageView.do {
            $0.image = .icTextHot
            $0.contentMode = .scaleAspectFit
        }
        
        titleLabel.do {
            $0.applyWSSFont(.headline1, with: StringLiterals.Home.Title.realtimePopular)
            $0.textColor = .wssBlack
        }
        
        titleStackView.do {
            $0.axis = .horizontal
            $0.spacing = 6
        }
        
        realtimePopularCollectionView.do {
            $0.showsHorizontalScrollIndicator = false
        }
        
        realtimePopularCollectionViewLayout.do {
            $0.scrollDirection = .horizontal
            $0.minimumLineSpacing = 10
            $0.itemSize = CGSize(width: 335, height: 414)
            $0.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            realtimePopularCollectionView.setCollectionViewLayout($0, animated: false)
        }
    }
    
    private func setHierarchy() {
        titleStackView.addArrangedSubviews(titleLogoImageView,
                                           titleLabel)
        self.addSubviews(titleStackView)
    }
    
    private func setLayout() {
        titleStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
    }
}
