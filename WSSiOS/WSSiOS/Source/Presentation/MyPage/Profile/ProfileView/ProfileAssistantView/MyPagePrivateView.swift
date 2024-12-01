//
//  MyPagePrivateView.swift
//  WSSiOS
//
//  Created by 신지원 on 11/29/24.
//

import UIKit

import SnapKit
import Then

final class MyPagePrivateView: UIView {
    
    //MARK: - Components
    
    private let isPrivateImageView = UIImageView()
    let isPrivateDescriptionLabel = UILabel()
    
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
        
        isPrivateImageView.do {
            $0.image = .imgPrivateCat
            $0.contentMode = .scaleAspectFit
        }
        
        isPrivateDescriptionLabel.do {
            $0.textColor = .wssGray200
            $0.numberOfLines = 2
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(isPrivateImageView,
                         isPrivateDescriptionLabel)
    }
    
    private func setLayout() {
        isPrivateImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(58)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(166)
            $0.height.equalTo(160)
        }
        
        isPrivateDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(isPrivateImageView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
    }
}
