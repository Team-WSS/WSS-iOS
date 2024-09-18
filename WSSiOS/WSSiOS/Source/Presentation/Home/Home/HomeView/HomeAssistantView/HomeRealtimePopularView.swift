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
    
    /// 지금 뜨는 수다글 제목 UI
    private var titleLogoImageView = UIImageView()
    private var titleLabel = UILabel()
    private var titleStackView = UIStackView()
    
    /// 지금 뜨는 수다글 캐로셀 UI
    let realtimePopularCollectionView = UICollectionView(frame: .zero,
                                                         collectionViewLayout: UICollectionViewLayout())
    private let realtimePopularCollectionViewLayout = UICollectionViewFlowLayout()
    
    private let testView = HomeRealtimePopularCollectionViewCell()
    
    private let dotStackView = UIStackView()
    private let firstDotImageView = UIImageView()
    private let secondDotImageView = UIImageView()
    private let thirdDotImageView = UIImageView()
    
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
            $0.isPagingEnabled = false
            $0.isScrollEnabled = true
            $0.contentInsetAdjustmentBehavior = .never
            $0.decelerationRate = .fast
        }
        
        realtimePopularCollectionViewLayout.do {
            $0.scrollDirection = .horizontal
            $0.minimumLineSpacing = 10
            $0.itemSize = CGSize(width: 335, height: 414)
            $0.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            realtimePopularCollectionView.setCollectionViewLayout($0, animated: false)
        }
        
        dotStackView.do {
            $0.axis = .horizontal
            $0.spacing = 6
        }
        
        firstDotImageView.do {
            $0.image = .icCarouselSelected
            $0.contentMode = .scaleAspectFit
        }
        
        [secondDotImageView, thirdDotImageView].forEach {
            $0.image = .icCarousel
            $0.contentMode = .scaleAspectFit
        }
    }
    
    private func setHierarchy() {
        titleStackView.addArrangedSubviews(titleLogoImageView,
                                           titleLabel)
        
        dotStackView.addArrangedSubviews(firstDotImageView,
                                         secondDotImageView,
                                         thirdDotImageView)
        
        self.addSubviews(titleStackView,
                         realtimePopularCollectionView,
                         dotStackView)
        
    }
    
    private func setLayout() {
        titleStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
        
        realtimePopularCollectionView.snp.makeConstraints {
            $0.top.equalTo(titleStackView.snp.bottom).offset(14)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(414)
        }
        
        dotStackView.snp.makeConstraints {
            $0.top.equalTo(realtimePopularCollectionView.snp.bottom).offset(14)
            $0.centerX.bottom.equalToSuperview()
        }
    }
}
