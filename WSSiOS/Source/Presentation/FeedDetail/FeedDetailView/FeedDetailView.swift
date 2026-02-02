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
    let dropdownButton = UIButton()
    let dropdownView = FeedDetailDropdownView()
    
    let profileView = FeedDetailProfileView()
    let feedContentView = FeedDetailContentView()
    let replyView = FeedDetailReplyView()
    let replyWritingView = FeedDetailReplyWritingView()
    let replyDropdownView = FeedDetailDropdownView()
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
        
        dropdownButton.do {
            $0.setImage(.icThreedots.withRenderingMode(.alwaysOriginal).withTintColor(.wssBlack), for: .normal)
        }
        
        dropdownView.do {
            $0.isHidden = true
        }
        
        replyDropdownView.do {
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
                         replyDropdownView,
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
        
        replyDropdownView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
        }
        
        profileView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(20)
        }
        
        feedContentView.snp.makeConstraints {
            $0.top.equalTo(profileView.snp.bottom).offset(14)
            $0.leading.trailing.equalToSuperview()
        }
        
        replyView.snp.makeConstraints {
            $0.top.equalTo(feedContentView.snp.bottom).offset(16)
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
    
    func bindData(_ data: FeedEntity) {
        profileView.bindData(data: data)
        feedContentView.bindData(data: data)
    }
    
    func showLoadingView(isShow: Bool) {
        loadingView.isHidden = !isShow
    }
    
    func showNetworkErrorView() {
        networkErrorView.isHidden = false
    }
    
    //MARK: - Reply Dropdown View Methods
    
    func showReplyDropdownView(indexPath: IndexPath, isMyComment: Bool) {
        replyDropdownView.do {
            $0.configureDropdown(isMine: isMyComment)
            $0.isHidden = false
        }
        updateReplyDropdownViewLayout(indexPath: indexPath)
    }
    
    func hideReplyDropdownView() {
        replyDropdownView.isHidden = true
    }
    
    func toggleReplyDropdownView() {
        replyDropdownView.isHidden.toggle()
    }
    
    func updateReplyDropdownViewLayout(indexPath: IndexPath) {
        guard let cell = replyView.replyCollectionView.cellForItem(at: indexPath) else { return }
        
        let cellFrameInSuperview = cell.convert(cell.bounds, to: self)
        let numberOfItems = replyView.replyCollectionView.numberOfItems(inSection: indexPath.section)
        let isLastTwoCells = indexPath.item >= numberOfItems - 2
        
        replyDropdownView.snp.updateConstraints {
            $0.top.equalToSuperview().inset(isLastTwoCells ? cellFrameInSuperview.minY - replyDropdownView.frame.height : cellFrameInSuperview.minY + 40)
            $0.trailing.equalToSuperview().inset(20)
        }
    }
}
