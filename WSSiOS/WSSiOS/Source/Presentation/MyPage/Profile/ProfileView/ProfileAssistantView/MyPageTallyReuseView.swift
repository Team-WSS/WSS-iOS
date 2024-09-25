//
//  MyPageTallyReuseView.swift
//  WSSiOS
//
//  Created by 신지원 on 1/10/24.
//

import UIKit

import SnapKit
import Then

final class MyPageTallyReuseView: UIView {
    
    //MARK: - Components
    
    let titleView = UIStackView()
    let titleIconImageView = UIImageView()
    let titleLabel = UILabel()
    let tallyLabel = UILabel()
    
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
        
        titleView.do {
            $0.axis = .horizontal
            $0.alignment = .center
            $0.distribution = .fill
            $0.spacing = 4
            
            titleLabel.do {
                $0.font = .Body2
                $0.textColor = .wssGray300
            }
        }
        
        tallyLabel.do {
            $0.font = .Title1
            $0.textColor = .wssBlack
        }
    }

    private func setHierarchy() {
        self.addSubviews(titleView,
                         tallyLabel)
        titleView.addArrangedSubviews(titleIconImageView,
                                      titleLabel)
    }

    private func setLayout() {
        titleView.snp.makeConstraints() {
            $0.top.centerX.equalToSuperview()
            
            titleIconImageView.snp.makeConstraints() {
                $0.size.equalTo(18)
            }
        }
        
        tallyLabel.snp.makeConstraints() {
            $0.top.equalTo(titleView.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(5)
        }
    }
}
