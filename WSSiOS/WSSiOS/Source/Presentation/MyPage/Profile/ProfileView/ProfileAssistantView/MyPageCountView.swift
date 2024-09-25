//
//  MyPageCountView.swift
//  WSSiOS
//
//  Created by 신지원 on 7/26/24.
//

import UIKit

import SnapKit
import Then

final class MyPageCountView: UIView {
    
    //MARK: - Properties
    
    private var maxLimit: Int
    
    //MARK: - Components
    
    var countLabel = UILabel()
    private let countLimitLabel = UILabel()
    
    // MARK: - Life Cycle
    
    init(maxLimit: Int) {
        self.maxLimit = maxLimit
        super.init(frame: .zero)
        
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
        
        countLabel.do {
            $0.applyWSSFont(.label1, with: "0")
            $0.textColor = .wssGray300
        }
        
        countLimitLabel.do {
            $0.applyWSSFont(.label1, with: " / " + String(maxLimit))
            $0.textColor = .wssGray200
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(countLimitLabel,
                         countLabel)
    }
    
    private func setLayout() {
        countLimitLabel.snp.makeConstraints {
            $0.top.bottom.trailing.equalToSuperview()
        }
        
        countLabel.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.trailing.equalTo(countLimitLabel.snp.leading)
        }
    }
}
