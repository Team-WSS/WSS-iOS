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
    
    private let backgroundView = UIView()
    private let topDividerView = UIView()
    private let bottomDividerView = UIView()
    
    private let dotStackView = UIStackView()
    private var dotImageViews: [UIImageView] = []
    
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
            $0.minimumLineSpacing = 0
            $0.itemSize = CGSize(width: UIScreen.main.bounds.width - 40, height: 414)
            realtimePopularCollectionView.setCollectionViewLayout($0, animated: false)
        }
        
        backgroundView.do {
            $0.layer.borderColor = UIColor.wssGray70.cgColor
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 14
        }
        
        [topDividerView, bottomDividerView].forEach {
            $0.backgroundColor = .wssGray70
        }
        
        dotStackView.do {
            $0.axis = .horizontal
            $0.spacing = 6
        }
    }
    
    private func setHierarchy() {
        titleStackView.addArrangedSubviews(titleLogoImageView,
                                           titleLabel)
        backgroundView.addSubviews(realtimePopularCollectionView,
                                   topDividerView,
                                   bottomDividerView)
        self.addSubviews(titleStackView,
                         backgroundView,
                         dotStackView)
    }
    
    private func setLayout() {
        titleStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
        
        backgroundView.snp.makeConstraints {
            $0.top.equalTo(titleStackView.snp.bottom).offset(14)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(414)
            
            realtimePopularCollectionView.snp.makeConstraints {
                $0.top.horizontalEdges.equalToSuperview()
                $0.height.equalTo(414)
            }
            
            topDividerView.snp.makeConstraints {
                $0.top.equalToSuperview().inset(138)
                $0.horizontalEdges.equalToSuperview()
                $0.height.equalTo(1)
            }
            
            bottomDividerView.snp.makeConstraints {
                $0.bottom.equalToSuperview().inset(138)
                $0.horizontalEdges.equalToSuperview()
                $0.height.equalTo(1)
            }
        }
        
        dotStackView.snp.makeConstraints {
            $0.top.equalTo(backgroundView.snp.bottom).offset(14)
            $0.centerX.bottom.equalToSuperview()
        }
    }
    
    func configureDots(numberOfItems: Int) {
        self.dotStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        self.dotImageViews.removeAll()
        
        for i in 0..<numberOfItems {
            let dotImageView = UIImageView()
            dotImageView.contentMode = .scaleAspectFit
            dotImageView.image = i == 0 ? .icCarouselSelected : .icCarousel
            self.dotStackView.addArrangedSubview(dotImageView)
            self.dotImageViews.append(dotImageView)
        }
    }
    
    func updateDots(currentPage: Int) {
        dotImageViews.enumerated().forEach { index, imageView in
            imageView.image = index == currentPage ? .icCarouselSelected : .icCarousel
        }
    }
}
