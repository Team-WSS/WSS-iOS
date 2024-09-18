//
//  MyPageProfileVisibilityView.swift
//  WSSiOS
//
//  Created by 신지원 on 9/18/24.
//

import UIKit

import SnapKit
import Then

final class MyPageProfileVisibilityView: UIView {
    
    //MARK: - Components
    
    private let profilePrivateView = UIView()
    private let profilePrivateLabel = UILabel()
    let profilePrivateToggleButton = UIButton()
    
    //In VC
    let backButton = UIButton()
    let completeButton = UIButton()
    
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
        
        profilePrivateView.do {
            $0.backgroundColor = .wssWhite
        }
        
        profilePrivateLabel.do {
            $0.textColor = .wssBlack
            $0.applyWSSFont(.body1, with: StringLiterals.MyPage.isVisiableProfile.isPrivateProfile)
        }
        
        profilePrivateToggleButton.do {
            $0.setImage(.icUnSelectNovel, for: .normal)
        }
        
        backButton.do {
            $0.setImage(.icNavigateLeft.withTintColor(.wssGray300, renderingMode: .alwaysTemplate),
                        for: .normal)
        }
        
        completeButton.do {
            $0.setTitle(StringLiterals.MyPage.isVisiableProfile.completeTitle, for: .normal)
            $0.setTitleColor(.wssPrimary100, for: .normal)
            $0.titleLabel?.applyWSSFont(.title2, with: StringLiterals.MyPage.isVisiableProfile.completeTitle)
        }
    }
    
    private func setHierarchy() {
        self.addSubview(profilePrivateView)
        profilePrivateView.addSubviews(profilePrivateLabel,
                                       profilePrivateToggleButton)
    }
    
    private func setLayout() {
        profilePrivateView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.width.equalToSuperview()
            $0.height.equalTo(63)
        }
        
        profilePrivateLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(40)
            $0.centerY.equalToSuperview()
        }
        
        profilePrivateToggleButton.snp.makeConstraints {
            $0.size.equalTo(44)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
        }
        
        backButton.snp.makeConstraints {
            $0.size.equalTo(44)
        }
        
        completeButton.snp.makeConstraints {
            $0.width.equalTo(48)
            $0.height.equalTo(42)
        }
    }
    
    //MARK: - Data
    
    func bindData(isPrivate: Bool) {
        profilePrivateToggleButton.setImage(isPrivate ? .icSelectNovel : .icUnSelectNovel,
                                            for: .normal)
    }
    
}

