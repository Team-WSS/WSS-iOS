//
//  FeedEditPrivateSettingView.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 4/9/25.
//

import UIKit

import SnapKit
import Then

final class FeedEditPrivateSettingView: UIView {
    
    //MARK: - Components
    
    private let lockImageView = UIImageView()
    private let privateSettingLabel = UILabel()
    private let privateSettingButton = WSSToggleButton()
    
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
    
    private func setUI() {
        self.backgroundColor = .wssGray300
        
        lockImageView.do {
            $0.image = .icLock
        }
        
        privateSettingLabel.do {
            $0.applyWSSFont(.title3, with: StringLiterals.FeedEdit.setPrivate)
            $0.textColor = .wssGray50
        }
        
        privateSettingButton.do {
            $0.setToggleSize(
                toggleSize: CGSize(width: 42, height: 42),
                barViewSize: CGSize(width: 40, height: 22),
                circleViewSize: CGSize(width: 18, height: 18),
                onCircleInset: 2
            )
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(lockImageView,
                         privateSettingLabel,
                         privateSettingButton)
    }
    
    private func setLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(58)
        }
        
        lockImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
        
        privateSettingLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(lockImageView.snp.trailing).offset(4)
        }
        
        privateSettingButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
        }
    }
}
