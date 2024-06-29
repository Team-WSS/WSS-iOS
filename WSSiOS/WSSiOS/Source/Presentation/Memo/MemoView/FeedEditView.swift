//
//  FeedEditView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 6/29/24.
//

import UIKit

import SnapKit
import Then

final class FeedEditView: UIView {
    
    //MARK: - Components
    
    let backButton = UIButton()
    let completeButton = UIButton()
    let scrollView = UIScrollView()
    private let contentView = UIStackView()
    let feedCategoryView = FeedCategoryView()
    let feedContentView = FeedContentView()
    let feedNovelConnectView = FeedNovelConnectView()
    
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
        self.do {
            $0.backgroundColor = .wssWhite
        }
        
        backButton.do {
            $0.setImage(.icNavigateLeft.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        completeButton.do {
            $0.setButtonAttributedTitle(text: StringLiterals.Memo.complete, font: .Title2, color: .wssPrimary100)
            $0.isEnabled = false
        }
        
        scrollView.do {
            $0.contentInsetAdjustmentBehavior = .never
            $0.showsVerticalScrollIndicator = false
            $0.contentInset = UIEdgeInsets(top: 14.0, left: 0.0, bottom: 80.0, right: 0.0)
        }
        
        contentView.do {
            $0.alignment = .fill
            $0.axis = .vertical
            $0.spacing = 42
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(scrollView)
        scrollView.addSubview(contentView)
        contentView.addArrangedSubviews(feedCategoryView,
                                        feedContentView,
                                        feedNovelConnectView)
    }
    
    private func setLayout() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalToSuperview()
        }
    }
    
    //MARK: - Custom Method
    
    func enableCompleteButton(isAbled: Bool) {
        if isAbled {
            completeButton.do {
                $0.setButtonAttributedTitle(text: StringLiterals.Memo.complete, font: .Title2, color: .wssPrimary100)
                $0.isEnabled = true
            }
        } else {
            completeButton.do {
                $0.setButtonAttributedTitle(text: StringLiterals.Memo.complete, font: .Title2, color: .wssGray200)
                $0.isEnabled = false
            }
        }
    }
}
