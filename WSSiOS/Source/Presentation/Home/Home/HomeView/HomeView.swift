//
//  HomeView.swift
//  WSSiOS
//
//  Created by 최서연 on 1/9/24.
//

import UIKit

import SnapKit
import Then

final class HomeView: UIView {
    
    //MARK: - UI Components
    
    let scrollView = UIScrollView()
    private let contentView = UIView()
    let headerView = HomeHeaderView()
    let searchBarView = SearchBarView()
    let induceDetailSearchView = HomeInduceDetailSearchView()
    let todayPopularView = HomeTodayPopularView()
    let realtimePopularView = HomeRealtimePopularView()
    let tasteRecommendView = HomeTasteRecommendView()
    
    let loadingView = WSSLoadingView()
    
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
        scrollView.do {
            $0.showsVerticalScrollIndicator = false
        }
        
        loadingView.do {
            $0.isHidden = true
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(headerView,
                         scrollView,
                         loadingView)
        self.scrollView.addSubview(contentView)
        contentView.addSubviews(searchBarView,
                                induceDetailSearchView,
                                todayPopularView,
                                realtimePopularView,
                                tasteRecommendView)
    }
    
    private func setLayout() {
        headerView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            $0.height.equalTo(50)
            $0.leading.trailing.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        loadingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.top.equalTo(scrollView.contentLayoutGuide)
            $0.leading.trailing.bottom.equalTo(scrollView.contentLayoutGuide)
            $0.height.greaterThanOrEqualTo(self.snp.height).priority(.low)
            $0.width.equalTo(scrollView.snp.width)
        }
        
        searchBarView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(42)
        }
        
        induceDetailSearchView.snp.makeConstraints {
            $0.top.equalTo(searchBarView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        todayPopularView.snp.makeConstraints {
            $0.top.equalTo(induceDetailSearchView.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview()
        }
        
        realtimePopularView.snp.makeConstraints {
            $0.top.equalTo(todayPopularView.snp.bottom).offset(32)
            $0.horizontalEdges.equalToSuperview()
        }
        
        tasteRecommendView.snp.makeConstraints {
            $0.top.equalTo(realtimePopularView.snp.bottom).offset(40)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    //MARK: - Custom Methods
    
    func showLoadingView(isShow: Bool) {
        loadingView.do {
            $0.isHidden = !isShow
        }
    }
}
