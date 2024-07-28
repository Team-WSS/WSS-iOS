//
//  NovelDetailView.swift
//  WSSiOS
//
//  Created by 이윤학 on 4/25/24.
//

import UIKit

import SnapKit
import Then

final class NovelDetailView: UIView {
    
    //MARK: - Components
    
    let statusBarView = UIView()
    let scrollView = UIScrollView()
    private let contentView = UIStackView()
    
    let headerView = NovelDetailHeaderView()
    let largeNovelCoverImageButton = NovelDetailLargeCoverImageButton()
    let stickyTabBarView = NovelDetailTabBarView()
    let tabBarView = NovelDetailTabBarView()
    
    let infoView = NovelDetailInfoView()
    let feedView = NovelDetailFeedView()
    
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
        self.backgroundColor = .wssWhite
        
        statusBarView.do {
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
            let statusBarManager = windowScene?.windows.first?.windowScene?.statusBarManager
            $0.frame = statusBarManager?.statusBarFrame ?? .zero
        }
        
        stickyTabBarView.do {
            $0.isHidden = true
        }
        
        feedView.do {
            $0.isHidden = true
        }
        
        scrollView.do {
            $0.contentInsetAdjustmentBehavior = .never
            $0.showsVerticalScrollIndicator = false
        }
        
        contentView.do {
            $0.alignment = .fill
            $0.axis = .vertical
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(scrollView,
                         statusBarView,
                         stickyTabBarView,
                         largeNovelCoverImageButton)
        scrollView.addSubview(contentView)
        contentView.addArrangedSubviews(headerView,
                                        tabBarView,
                                        infoView,
                                        feedView)
    }
    
    private func setLayout() {
        stickyTabBarView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.horizontalEdges.top.equalTo(scrollView.contentLayoutGuide)
            $0.bottom.equalToSuperview().inset(1000)
            $0.width.equalToSuperview()
        }
        
        largeNovelCoverImageButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    //MARK: - Data
    
    func bindData(_ data: NovelDetailHeaderResult) {
        headerView.bindData(data)
        largeNovelCoverImageButton.bindData(data)
    }
    
    func updateStickyTabBarShow(_ isShow: Bool) {
        stickyTabBarView.isHidden = !isShow
    }
    
    func updateTab(selected tab: Tab) {
        tabBarView.updateTabBar(selected: tab)
        stickyTabBarView.updateTabBar(selected: tab)
        updateSelectedTabView(selected: tab)
    }
    
    private func updateSelectedTabView(selected tab: Tab) {
        switch tab {
        case .info:
            infoView.isHidden = false
            feedView.isHidden = true
        case .feed:
            infoView.isHidden = true
            feedView.isHidden = false
        }
    }
}
