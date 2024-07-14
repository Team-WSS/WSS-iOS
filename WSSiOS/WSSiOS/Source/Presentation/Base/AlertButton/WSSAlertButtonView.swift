//
//  AlertButtonView.swift
//  WSSiOS
//
//  Created by 신지원 on 7/14/24.
//

import UIKit

import SnapKit
import Then

final class WSSAlertButtonView: UIView {
    
    //MARK: - Properties
    
    var cancelButtonEnable = String()
    var actionButtonEnable: (String, CGColor) = ("", UIColor.clear.cgColor)
    
    // MARK: - UI Components
    
    private let alertView = UIView()
    private let stackView = UIStackView()
    var alertImageView = UIImageView()
    var alertTitleLabel = UILabel()
    var alertContentLabel = UILabel()
    private let buttonStackView = UIStackView()
    var cancelButton = UIButton()
    var actionButton = UIButton()
    
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
    
    // MARK: - Custom Method
    
    private func setUI() {
        self.backgroundColor = .wssBlack.withAlphaComponent(0.6)
        
        alertView.do {
            $0.backgroundColor = .wssWhite
            $0.layer.cornerRadius = 12
        }
        
        stackView.do {
            $0.axis = .vertical
            $0.alignment = .center
        }
        
        alertTitleLabel.do {
            $0.textColor = .wssBlack
            $0.applyWSSFont(.title1, with: "하하하")
            $0.numberOfLines = 0
            $0.textAlignment = .center
        }
        
        alertContentLabel.do {
            $0.textColor = .wssGray300
            $0.applyWSSFont(.body2, with: "해당 글이 커뮤니티 가이드를\n위반했는지 검토할게요")
            $0.numberOfLines = 0
            $0.textAlignment = .center
        }
        
        buttonStackView.do {
            $0.axis = .horizontal
            $0.distribution = .fill
        }
        
        cancelButton.do {
            $0.setTitle("취소", for: .normal)
            $0.layer.backgroundColor = UIColor.wssGray50.cgColor
            $0.layer.cornerRadius = 8
            $0.titleLabel?.font = .Label1
            $0.titleLabel?.textColor = .wssGray300
        }
        
        actionButton.do {
            $0.setTitle("차단", for: .normal)
            $0.layer.backgroundColor = UIColor.wssSecondary100.cgColor
            $0.layer.cornerRadius = 8
            $0.titleLabel?.font = .Label1
            $0.titleLabel?.textColor = .wssWhite
        }
    }
    
    private func setHierarchy() {
        self.addSubview(alertView)
        alertView.addSubview(stackView)
        stackView.addArrangedSubviews(alertImageView,
                                      alertTitleLabel,
                                      alertContentLabel,
                                      buttonStackView)
        buttonStackView.addArrangedSubviews(cancelButton,
                                            actionButton)
    }
    
    private func setLayout() {
        alertView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(41)
        }
        
        stackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(24)
            $0.leading.trailing.equalToSuperview().inset(21)
        }
        
        stackView.do {
            $0.setCustomSpacing(18, after: alertImageView)
            $0.setCustomSpacing(4, after: alertTitleLabel)
            $0.setCustomSpacing(18, after: alertContentLabel)
        }
        
        alertImageView.snp.makeConstraints {
            $0.size.equalTo(60)
        }
        
        buttonStackView.do {
            $0.snp.makeConstraints {
                $0.width.equalToSuperview()
                $0.height.equalTo(40)
            }
            $0.setCustomSpacing(18, after: cancelButton)
        }
        
        [cancelButton, actionButton]
            .forEach { 
                $0.snp.makeConstraints {
                    $0.height.equalToSuperview()
                    $0.width.equalTo(116)
                }}
    }
}

extension WSSAlertButtonView {
    
}

