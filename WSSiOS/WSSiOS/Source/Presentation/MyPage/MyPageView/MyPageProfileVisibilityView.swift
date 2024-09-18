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
    
    let backButton = UIButton()
    let completeButton = UIButton()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
//        setHierarchy()
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
            $0.setImage(.icNavigateLeft.withTintColor(.wssGray300, renderingMode: .alwaysTemplate),
                        for: .normal)
        }
        
        completeButton.do {
            $0.setTitle(StringLiterals.MyPage.isVisiableProfile.completeTitle, for: .normal)
            $0.setTitleColor(.wssPrimary100, for: .normal)
            $0.titleLabel?.applyWSSFont(.title2, with: StringLiterals.MyPage.isVisiableProfile.completeTitle)
        }
    }
    
//    private func setHierarchy() {
//        self.addSubview()
//    }
    
    private func setLayout() {
        backButton.snp.makeConstraints {
            $0.size.equalTo(44)
        }
        
        completeButton.snp.makeConstraints {
            $0.width.equalTo(48)
            $0.height.equalTo(42)
        }
    }
    
    //MARK: - Data
    
}

