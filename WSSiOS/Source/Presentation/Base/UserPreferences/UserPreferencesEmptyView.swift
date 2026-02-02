//
//  UserPreferencesEmptyView.swift
//  WSSiOS
//
//  Created by 신지원 on 5/24/25.
//

import UIKit

import SnapKit
import Then

final class UserPreferencesEmptyView: UIView {

    //MARK: - Components
    
    private let userPreferencesEmptyImageView = UIImageView()
    private let userPreferencesEmptyLabel = UILabel()
    
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
        self.backgroundColor = .clear
        
        userPreferencesEmptyImageView.image = .imgEmptyCatQuestionmark
    
        userPreferencesEmptyLabel.do {
            $0.applyWSSFont(.body2, with: StringLiterals.MyPage.Profile.preferenceEmptyLabel)
            $0.textColor = .wssGray200
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(userPreferencesEmptyImageView,
                         userPreferencesEmptyLabel)
    }
    
    private func setLayout() {
        userPreferencesEmptyImageView.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
            $0.height.equalTo(160)
            $0.width.equalTo(166)
        }
        
        userPreferencesEmptyLabel.snp.makeConstraints {
            $0.top.equalTo(userPreferencesEmptyImageView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
    }
}
