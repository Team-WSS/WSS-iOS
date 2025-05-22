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
    
    let libraryButton = UIButton()
    let libraryUnderView = UIView()
    let libraryButtonLabel = UILabel()
    
    let feedButton = UIButton()
    let feedButtonLabel = UILabel()
    let feedUnderView = UIView()
    
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
        
        libraryButton.do {
            $0.backgroundColor = .wssWhite
            $0.isSelected = true
            
            libraryButtonLabel.do {
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
        
        libraryUnderView.do {
            $0.backgroundColor = .wssBlack
            $0.isHidden = false
        }
        
        feedUnderView.do {
            $0.backgroundColor = .wssBlack
            $0.isHidden = true
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(libraryButton,
                         feedButton,
                         underLineView,
                         libraryUnderView,
                         feedUnderView)
        libraryButton.addSubview(libraryButtonLabel)
        feedButton.addSubview(feedButtonLabel)
    }
    
    private func setLayout() {
        underLineView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(1)
            $0.width.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        libraryButton.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.trailing.equalTo(super.snp.centerX)
            
            libraryButtonLabel.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
        }
        
        libraryUnderView.snp.makeConstraints {
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
    
    func updateSelection(isLibrarySelected: Bool) {
        libraryButton.isSelected = isLibrarySelected
        feedButton.isSelected = !isLibrarySelected
        
        libraryButtonLabel.textColor = isLibrarySelected ? .wssBlack : .wssGray100
        feedButtonLabel.textColor = isLibrarySelected ? .wssGray100 : .wssBlack
        
        libraryUnderView.isHidden = !isLibrarySelected
        feedUnderView.isHidden = isLibrarySelected
    }
}
