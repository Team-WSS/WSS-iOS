//
//  FeedDetailView.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 6/23/24.
//

import UIKit

import SnapKit
import Then

final class FeedDetailView: UIView {
    
    //MARK: - Components
    
    let scrollView = UIScrollView()
    private let contentView = UIView()
    
    let backButton = UIButton()
    let viewTitleLabel = UILabel()
    let dropdownButton = UIButton()
    let dropdownView = FeedDetailDropdownView()
    
    let profileView = FeedDetailProfileView()
    let feedContentView = FeedDetailContentView()
    let replyView = FeedDetailReplyView()
    let replyWritingView = FeedDetailReplyWritingView()
    private let replyBottomView = UIView()
    
    private let loadingView = WSSLoadingView()
    private let networkErrorView = WSSNetworkErrorView()
    
    // MARK: - Life Cycle
    
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
        self.do {
            $0.backgroundColor = .wssWhite
        }
        
        backButton.do {
            $0.setImage(.icNavigateLeft.withRenderingMode(.alwaysOriginal).withTintColor(.wssBlack), for: .normal)
        }
        
        viewTitleLabel.do {
            $0.applyWSSFont(.title2, with: StringLiterals.FeedDetail.title)
            $0.textColor = .wssBlack
        }
        
        dropdownButton.do {
            $0.setImage(.icThreedots.withRenderingMode(.alwaysOriginal).withTintColor(.wssGray100), for: .normal)
        }
        
        dropdownView.do {
            $0.isHidden = true
        }
        
        replyBottomView.do {
            $0.backgroundColor = .wssWhite
        }
        
        loadingView.do {
            $0.isHidden = true
        }
        
        networkErrorView.do {
            $0.isHidden = true
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(scrollView,
                         replyWritingView,
                         replyBottomView,
                         dropdownView,
                         loadingView,
                         networkErrorView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(profileView,
                                feedContentView,
                                replyView)
    }
    
    private func setLayout() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.snp.width)
        }
        
        backButton.snp.makeConstraints {
            $0.size.equalTo(24)
        }
        
        dropdownButton.snp.makeConstraints {
            $0.size.equalTo(38)
        }
        
        dropdownView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        profileView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(20)
        }
        
        feedContentView.snp.makeConstraints {
            $0.top.equalTo(profileView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
        }
        
        replyView.snp.makeConstraints {
            $0.top.equalTo(feedContentView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        replyWritingView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
        
        replyBottomView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.bottomMargin)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        loadingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        networkErrorView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    //MARK: - Custom Methods
    
    func bindData(_ data: Feed) {
        profileView.bindData(data: data)
        feedContentView.bindData(data: data)
    }
    
    func showLoadingView(isShow: Bool) {
        loadingView.isHidden = !isShow
    }
    
    func showNetworkErrorView() {
        networkErrorView.isHidden = false
    }
}
