//
//  MyPagePreferencesEmptyView.swift
//  WSSiOS
//
//  Created by 신지원 on 11/16/24.
//

import UIKit

import SnapKit
import Then

final class MyPagePreferencesEmptyView: UIView {

    //MARK: - Components
    
    private let titleLabel = UILabel()
    private let emptyImage = UIImageView()
    private let emptyLabel = UILabel()
    
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
        self.backgroundColor = .wssWhite
        
        titleLabel.do {
            $0.applyWSSFont(.title1, with: StringLiterals.MyPage.Profile.preferenceEmpty)
            $0.textColor = .wssBlack
        }
        
        emptyImage.image = .imgEmptyCat
        
        emptyLabel.do {
            $0.applyWSSFont(.body2, with: StringLiterals.MyPage.Profile.preferenceEmptyLabel)
            $0.textColor = .wssGray200
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(titleLabel,
                         emptyImage,
                         emptyLabel)
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(30)
            $0.leading.equalToSuperview().inset(20)
        }
        
        emptyImage.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(35)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(160)
            $0.width.equalTo(166)
        }
        
        emptyLabel.snp.makeConstraints {
            $0.top.equalTo(emptyImage.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
    }
}


