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
    let headerDropDownButton = UIButton()
    let headerDropDownView = NovelDetailHeaderDropdownView()
    
    let headerView = NovelDetailHeaderView()
    let largeNovelCoverImageButton = NovelDetailLargeCoverImageButton()
    let firstReviewDescriptionBackgroundView = UIButton()
    let firstReviewDescriptionReviewButtonView = NovelDetailHeaderReviewResultView()
    let firstReviewDescriptionLabel = UILabel()
    let firstReviewDescriptionLabelBackgroundView = UIImageView()
    
    let stickyTabBarView = NovelDetailTabBarView()
    let tabBarView = NovelDetailTabBarView()
    
    let infoView = NovelDetailInfoView()
    let feedView = NovelDetailFeedView()
    
    let createFeedButton = DifferentRadiusButton()
    
    let networkErrorView = WSSNetworkErrorView()
    let loadingView = WSSLoadingView()
    
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
        
        headerDropDownButton.do {
            $0.setImage(.icThreedots.withRenderingMode(.alwaysTemplate),
                      for: .normal)
            $0.tintColor = .wssBlack
        }
        
        firstReviewDescriptionBackgroundView.do {
            $0.backgroundColor = .wssBlack60
        }
        
        firstReviewDescriptionReviewButtonView.do {
            $0.isUserInteractionEnabled = false
        }
        
        firstReviewDescriptionLabel.do {
            $0.applyWSSFont(.body3, with: StringLiterals.NovelDetail.Header.firstReviewDescription)
            $0.textColor = .wssPrimary100
            $0.numberOfLines = 2
            $0.isUserInteractionEnabled = false
        }
        
        firstReviewDescriptionLabelBackgroundView.do {
            $0.image = .imgSpeechBalloon
            $0.contentMode = .scaleAspectFit
            $0.isUserInteractionEnabled = false
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
        
        networkErrorView.do {
            $0.isHidden = true
        }
        
        loadingView.do {
            $0.isHidden = false
        }
        
        headerDropDownView.do {
            $0.isHidden = true
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(scrollView,
                         statusBarView,
                         stickyTabBarView,
                         largeNovelCoverImageButton,
                         createFeedButton,
                         headerDropDownView,
                         firstReviewDescriptionBackgroundView,
                         networkErrorView,
                         loadingView)
        scrollView.addSubview(contentView)
        contentView.addArrangedSubviews(headerView,
                                        tabBarView,
                                        infoView,
                                        feedView)
        firstReviewDescriptionBackgroundView.addSubviews(
            firstReviewDescriptionReviewButtonView,
            firstReviewDescriptionLabelBackgroundView,
            firstReviewDescriptionLabel
        )
    }
    
    private func setLayout() {
        stickyTabBarView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        statusBarView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.top)
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
        
        networkErrorView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        loadingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        headerDropDownView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        firstReviewDescriptionBackgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        firstReviewDescriptionReviewButtonView.snp.makeConstraints {
            $0.edges.equalTo(headerView.reviewResultView.snp.edges)
        }
        
        firstReviewDescriptionLabelBackgroundView.snp.makeConstraints {
            $0.top.equalTo(firstReviewDescriptionReviewButtonView.snp.bottom).offset(6)
            $0.width.equalTo(147)
            $0.height.equalTo(64)
            $0.centerX.equalToSuperview()
        }
        
        firstReviewDescriptionLabel.snp.makeConstraints {
            $0.bottom.equalTo(firstReviewDescriptionLabelBackgroundView.snp.bottom).offset(-8)
            $0.centerX.equalToSuperview()
        }
    }
    
    //MARK: - Data
    
    func bindHeaderData(_ data: NovelDetailHeaderEntity) {
        headerView.bindData(data)
    }
    
    func bindHeaderImage(novelImage: UIImage, genreImage: UIImage) {
        headerView.bindImage(novelImage: novelImage, novelGenreImage: genreImage)
        largeNovelCoverImageButton.bindData(novelImage)
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
    
    func showNetworkErrorView(isShow: Bool) {
        networkErrorView.do {
            $0.isHidden = !isShow
        }
    }
    
    func showLoadingView(isShow: Bool) {
        loadingView.do {
            $0.isHidden = !isShow
        }
    }
    
    func showHeaderDropDownView(isShow: Bool) {
        headerDropDownView.do {
            $0.isHidden = !isShow
        }
    }
    
    func showFirstDescriptionView(isHidden: Bool) {
        firstReviewDescriptionBackgroundView.isHidden = isHidden
        firstReviewDescriptionLabel.isHidden = isHidden
        firstReviewDescriptionReviewButtonView.isHidden = isHidden
        firstReviewDescriptionLabelBackgroundView.isHidden = isHidden
    }
}
