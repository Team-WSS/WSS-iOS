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
    let dotsButton = UIButton()
    
    let profileView = FeedDetailProfileView()
    let feedContentView = FeedDetailContentView()
    let replyView = FeedDetailReplyView()
    let replyWritingView = FeedDetailReplyWritingView()
    
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
        
        dotsButton.do {
            $0.setImage(.icThreedots.withRenderingMode(.alwaysOriginal).withTintColor(.wssGray100), for: .normal)
        }
        
        scrollView.do {
            $0.showsVerticalScrollIndicator = false
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(scrollView,
                         replyWritingView)
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
    }
    
    func bindData(data: Feed) {
        profileView.bindData(data: data)
        feedContentView.bindData(data: data)
    }
}
