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
    
    let backButton = UIButton()
    let dropDownButton = UIButton()
    
    let headerView = NovelDetailHeaderView()
    let largeNovelCoverImageButton = NovelDetailLargeCoverImageButton()
    let stickyTabBarView = NovelDetailTabBarView()
    let tabBarView = NovelDetailTabBarView()
    
    let infoView = NovelDetailInfoView()
    let feedView = NovelDetailFeedView()
    
    let createFeedButton = DifferentRadiusButton()
    
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
        
        backButton.setImage(.icNavigateLeft.withTintColor(.wssBlack),
                            for: .normal)
        
        dropDownButton.do {
            $0.setImage(.icDropDownDot.withRenderingMode(.alwaysTemplate),
                      for: .normal)
            $0.tintColor = .wssBlack
        }
        
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
        
        createFeedButton.do {
            $0.backgroundColor = .wssBlack
            $0.setImage(.icPencilSmall, for: .normal)
            $0.topLeftRadius = 32.5
            $0.topRightRadius = 32.5
            $0.bottomLeftRadius = 32.5
            $0.bottomRightRadius = 10.0
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(scrollView,
                         statusBarView,
                         stickyTabBarView,
                         largeNovelCoverImageButton,
                         createFeedButton)
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
            $0.bottom.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        largeNovelCoverImageButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        createFeedButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(26)
            $0.bottom.equalTo(self.safeAreaLayoutGuide).inset(10)
            $0.size.equalTo(65)
        }
    }
    
    //MARK: - Data
    
    func bindHeaderData(_ data: NovelDetailHeaderEntity) {
        headerView.bindData(data)
        largeNovelCoverImageButton.bindData(data.novelImage)
    }
    
    func bindInfoData(_ data: NovelDetailInfoResult) {
        infoView.bindData(data)
    }
    
    func updateStickyTabBarShow(_ isShow: Bool) {
        stickyTabBarView.isHidden = !isShow
    }
    
    func updateTab(selected tab: Tab) {
        tabBarView.updateTabBar(selected: tab)
        stickyTabBarView.updateTabBar(selected: tab)
        updateSelectedTabView(selected: tab)
    }
    
    func showCreateFeedButton(show: Bool) {
        createFeedButton.isHidden = !show
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
