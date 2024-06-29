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
                                        feedContentView)
    }
    
    private func setLayout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalToSuperview()
        }
        
        feedCategoryView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).inset(14)
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
