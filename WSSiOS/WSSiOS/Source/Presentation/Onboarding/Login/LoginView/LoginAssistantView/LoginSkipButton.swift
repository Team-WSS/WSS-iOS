//
//  LoginSkipButton.swift
//  WSSiOS
//
//  Created by YunhakLee on 9/17/24.
//

import UIKit

import SnapKit
import Then

final class LoginSkipButton: UIView {
    
    //MARK: - Components
    
    let skipButtonLabel = UILabel()
    
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
            $0.backgroundColor = .clear
            $0.layer.cornerRadius = 14
            $0.layer.borderColor = UIColor.wssPrimary100.cgColor
            $0.layer.borderWidth = 1
        }
        
        skipButtonLabel.do {
            $0.applyWSSFont(.title1, with: StringLiterals.Onboarding.Login.skip)
            $0.textColor = .wssPrimary100
        }
    }
    
    private func setHierarchy() {
        self.addSubview(skipButtonLabel)
    }
    
    private func setLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(53)
        }
        
        skipButtonLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
