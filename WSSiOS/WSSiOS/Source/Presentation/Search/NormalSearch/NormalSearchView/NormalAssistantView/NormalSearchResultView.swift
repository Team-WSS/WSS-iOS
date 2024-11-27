//
//  NormalSearchResultView.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/27/24.
//

import UIKit

import SnapKit
import Then

final class NormalSearchResultView: UIView {
    
    //MARK: - Components
    
    let scrollView = UIScrollView()
    private let contentView = UIView()
    let resultCountView = NormalSearchResultCountView()
    let normalSearchCollectionView = UICollectionView(frame: .zero,
                                                      collectionViewLayout: UICollectionViewLayout())
    private let normalSearchCollectionViewLayout = UICollectionViewFlowLayout()
    private let infiniteScrollLoadingView = WSSInfiniteScrollLoadingView()
    
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
    
    //MARK: - UI
    
    private func setUI() {
        scrollView.do {
            $0.showsVerticalScrollIndicator = false
        }
        
        normalSearchCollectionView.do {
            $0.showsVerticalScrollIndicator = false
            $0.isUserInteractionEnabled = false
        }
        
        normalSearchCollectionViewLayout.do {
            $0.scrollDirection = .vertical
            $0.minimumLineSpacing = 6
            $0.itemSize = CGSize(width: 335, height: 105)
            $0.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
            normalSearchCollectionView.setCollectionViewLayout($0, animated: false)
        }
        
        infiniteScrollLoadingView.do {
            $0.isHidden = false
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(scrollView,
                        infiniteScrollLoadingView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(resultCountView,
                                normalSearchCollectionView)
    }
    
    private func setLayout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.height.greaterThanOrEqualTo(self.snp.height).priority(.low)
            $0.width.equalTo(scrollView.snp.width)
        }
        
        resultCountView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().inset(20)
        }
        
        normalSearchCollectionView.snp.makeConstraints {
            $0.top.equalTo(resultCountView.snp.bottom).offset(16)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(300)
        }
        
        infiniteScrollLoadingView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    //MARK: - Custom Method
    
    func updateCollectionViewHeight(height: CGFloat) {
        normalSearchCollectionView.snp.updateConstraints {
            $0.height.equalTo(height)
        }
    }
    
    func showInfiniteScrollLoadingView(isShow: Bool) {
        infiniteScrollLoadingView.isHidden = !isShow
    }
}
