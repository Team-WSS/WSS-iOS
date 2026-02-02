//
//  MyPageStickyHeaderView.swift
//  WSSiOS
//
//  Created by 신지원 on 11/17/24.
//

import UIKit

import SnapKit
import Then

final class UserPageStickyHeaderView: UIView {
    
    // MARK: - Components
    
    private let underLineView = UIView()
    
    let overviewButton = UIButton()
    private let overviewUnderView = UIView()
    private let overviewButtonLabel = UILabel()
    
    let feedButton = UIButton()
    private let feedButtonLabel = UILabel()
    private let feedUnderView = UIView()
    
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
    
    private func setUI() {
        underLineView.do {
            $0.backgroundColor = .wssGray70
        }
        
        overviewButton.do {
            $0.backgroundColor = .wssWhite
            $0.isSelected = true
            
            overviewButtonLabel.do {
                $0.textColor = .wssBlack
                $0.applyWSSFont(.body2, with: StringLiterals.MyPage.Profile.otherProfileLibrary)
            }
        }
        
        feedButton.do {
            $0.backgroundColor = .wssWhite
            $0.isSelected = false
            
            feedButtonLabel.do {
                $0.textColor = .wssBlack
                $0.applyWSSFont(.body2, with: StringLiterals.MyPage.Profile.otherProfileFeed)
            }
        }
        
        overviewUnderView.do {
            $0.backgroundColor = .wssBlack
            $0.isHidden = false
        }
        
        feedUnderView.do {
            $0.backgroundColor = .wssBlack
            $0.isHidden = true
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(overviewButton,
                         feedButton,
                         underLineView,
                         overviewUnderView,
                         feedUnderView)
        overviewButton.addSubview(overviewButtonLabel)
        feedButton.addSubview(feedButtonLabel)
    }
    
    private func setLayout() {
        underLineView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(1)
            $0.width.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        overviewButton.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.trailing.equalTo(super.snp.centerX)
            
            overviewButtonLabel.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
        }
        
        overviewUnderView.snp.makeConstraints {
            $0.leading.bottom.equalToSuperview()
            $0.height.equalTo(2)
            $0.trailing.equalTo(super.snp.centerX)
        }
        
        feedButton.snp.makeConstraints {
            $0.top.trailing.bottom.equalToSuperview()
            $0.leading.equalTo(super.snp.centerX)
            
            feedButtonLabel.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
        }
        
        feedUnderView.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview()
            $0.height.equalTo(2)
            $0.leading.equalTo(super.snp.centerX)
        }
    }
    
    func updateSelection(isOverviewSelected: Bool) {
        overviewButton.isSelected = isOverviewSelected
        feedButton.isSelected = !isOverviewSelected
        
        overviewButtonLabel.textColor = isOverviewSelected ? .wssBlack : .wssGray100
        feedButtonLabel.textColor = isOverviewSelected ? .wssGray100 : .wssBlack
        
        overviewUnderView.isHidden = !isOverviewSelected
        feedUnderView.isHidden = isOverviewSelected
    }
}
