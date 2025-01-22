//
//  MyPagePushNotificationView.swift
//  WSSiOS
//
//  Created by YunhakLee on 1/22/25.
//

import UIKit

import SnapKit
import Then

final class MyPagePushNotificationView: UIView {
    
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
            $0.setImage(.icSelectNovelDefault, for: .normal)
        }
        
        backButton.do {
            $0.setImage(.icNavigateLeft.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        completeButton.do {
            $0.setTitle(StringLiterals.MyPage.isVisiableProfile.completeTitle, for: .normal)
            $0.setTitleColor(.wssGray200, for: .normal)
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
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
        
        profilePrivateToggleButton.snp.makeConstraints {
            $0.size.equalTo(44)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
        }
    }
    
    //MARK: - Data
    
    func bindData(isPrivate: Bool) {
        profilePrivateToggleButton.setImage(isPrivate ? .icSelectNovelSelected : .icSelectNovelDefault,
                                            for: .normal)
    }
    
    func changeCompleteButton(change: Bool) {
        completeButton.do {
            $0.setTitleColor(change ? .wssPrimary100: .wssGray200,
                             for: .normal)
        }
    }
}
