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
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    let headerView = HomeHeaderView()
    let todayPopularView = HomeTodayPopularView()
    let realtimePopularView = HomeRealtimePopularView()
    let interestView: HomeInterestView
    let tasteRecommendView: HomeTasteRecommendView
    let induceLoginModalView = HomeInduceLoginModalView()
    
    //MARK: - Life Cycle
    
    init(frame: CGRect, isLoggedIn: Bool) {
        self.interestView = HomeInterestView(isLoggedIn: isLoggedIn)
        self.tasteRecommendView = HomeTasteRecommendView(isLoggedIn: isLoggedIn)
        super.init(frame: frame)
        
        setUI()
        setHierarchy()
        setLayout(isLoggedIn: isLoggedIn)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        scrollView.do {
            $0.showsVerticalScrollIndicator = false
        }
        
        induceLoginModalView.do {
            $0.isHidden = true
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(headerView,
                         scrollView,
                         induceLoginModalView)
        self.scrollView.addSubview(contentView)
        contentView.addSubviews(todayPopularView,
                                realtimePopularView,
                                interestView,
                                tasteRecommendView)
    }
    
    private func setLayout(isLoggedIn: Bool) {
        headerView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            $0.height.equalTo(50)
            $0.leading.trailing.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
        
        induceLoginModalView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.top.equalTo(scrollView.contentLayoutGuide).inset(18)
            $0.leading.trailing.bottom.equalTo(scrollView.contentLayoutGuide)
            $0.height.greaterThanOrEqualTo(self.snp.height).priority(.low)
            $0.width.equalTo(scrollView.snp.width)
        }
        
        todayPopularView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
        }
        
        realtimePopularView.snp.makeConstraints {
            $0.top.equalTo(todayPopularView.snp.bottom).offset(56)
            $0.horizontalEdges.equalToSuperview()
        }
        
        interestView.snp.makeConstraints {
            $0.top.equalTo(realtimePopularView.snp.bottom).offset(56)
            $0.horizontalEdges.equalToSuperview()
        }
        
        tasteRecommendView.snp.makeConstraints {
            $0.top.equalTo(interestView.snp.bottom).offset(isLoggedIn ? 36 : 56)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
}
