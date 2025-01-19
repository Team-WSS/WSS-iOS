//
//  MyPageStickyHeaderView.swift
//  WSSiOS
//
//  Created by 신지원 on 11/17/24.
//

import UIKit

import SnapKit
import Then

final class MyPageStickyHeaderView: UIView {
    
    // MARK: - Components
    
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
        libraryButton.do {
            $0.backgroundColor = .wssWhite
            $0.isSelected = true
        
            libraryButtonLabel.do {
                $0.textColor = .wssBlack
            }
        }
        
        feedButton.do {
            $0.backgroundColor = .wssWhite
            $0.isSelected = false
            
            feedButtonLabel.textColor = .wssBlack
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
                         libraryUnderView,
                         feedButton,
                         feedUnderView)
        libraryButton.addSubview(libraryButtonLabel)
        feedButton.addSubview(feedButtonLabel)
    }
    
    private func setLayout() {
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
    
    func buttonLabelText(isMyPage: Bool) {
        libraryButtonLabel.applyWSSFont(.body2, with: isMyPage ? StringLiterals.MyPage.Profile.myProfileLibrary : StringLiterals.MyPage.Profile.otherProfileLibrary)
        feedButtonLabel.applyWSSFont(.body2, with: isMyPage ? StringLiterals.MyPage.Profile.myProfileFeed : StringLiterals.MyPage.Profile.otherProfileFeed)
    }
}
