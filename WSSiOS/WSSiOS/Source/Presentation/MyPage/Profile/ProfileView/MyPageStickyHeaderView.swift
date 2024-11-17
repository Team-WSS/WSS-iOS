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
    let feedButton = UIButton()
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
            $0.setTitle("내 서재", for: .normal)
            $0.setTitleColor(.wssBlack, for: .normal)
            $0.titleLabel?.font = .Body2
            $0.isSelected = true
        }
        
        feedButton.do {
            $0.backgroundColor = .wssWhite
            $0.setTitle("내 활동", for: .normal)
            $0.setTitleColor(.wssBlack, for: .normal)
            $0.titleLabel?.font = .Body2
            $0.isSelected = false
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
    }
    
    private func setLayout() {
        libraryButton.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.trailing.equalTo(super.snp.centerX)
        }
        
        libraryUnderView.snp.makeConstraints {
            $0.leading.bottom.equalToSuperview()
            $0.height.equalTo(2)
            $0.trailing.equalTo(super.snp.centerX)
        }
        
        feedButton.snp.makeConstraints {
            $0.top.trailing.bottom.equalToSuperview()
            $0.leading.equalTo(super.snp.centerX)
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
        
        libraryButton.setTitleColor(isLibrarySelected ? .wssBlack : .wssGray300, for: .normal)
        feedButton.setTitleColor(isLibrarySelected ? .wssGray300 : .wssBlack, for: .normal)
        
        libraryUnderView.isHidden = !isLibrarySelected
        feedUnderView.isHidden = isLibrarySelected
    }
}
