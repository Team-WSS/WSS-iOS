//
//  MyPageFeedEmptyView.swift
//  WSSiOS
//
//  Created by 신지원 on 12/1/24.
//

import UIKit

import SnapKit
import Then


final class MyPageFeedEmptyView: UIView {
    
    //MARK: - Components
    
    private let isEmptyImageView = UIImageView()
    let isEmptyDescriptionLabel = UILabel()
    
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
        
        isEmptyImageView.do {
            $0.image = .imgFeedEmprtyCat
            $0.contentMode = .scaleAspectFit
        }
        
        isEmptyDescriptionLabel.do {
            $0.applyWSSFont(.body2, with: StringLiterals.MyPage.Profile.emptyFeed)
            $0.numberOfLines = 1
            $0.textColor = .wssGray200
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(isEmptyImageView,
                         isEmptyDescriptionLabel)
    }
    
    private func setLayout() {
        isEmptyImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(58)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(166)
            $0.height.equalTo(160)
        }
        
        isEmptyDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(isEmptyImageView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
    }
}

