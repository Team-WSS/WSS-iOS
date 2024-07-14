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
        
        buttonStackView.do {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.spacing = 18
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
        }
        
        [cancelButton, actionButton].forEach { button in
            button.snp.makeConstraints {
                $0.height.equalToSuperview()
            }
        }
    }
}

extension WSSAlertButtonView {
    func updateLayout(alertImage: UIImage?,
                      alertTitle: String?,
                      alertContent: String?,
                      cancelTitle: String?,
                      actionTitle: String?,
                      actionBackgroundColor: CGColor?) {
        
        if let alertImage {
            alertImageView.image = alertImage
        } else {
            alertImageView.removeFromSuperview()
        }
        
        if let alertTitle {
            alertTitleLabel.do {
                $0.applyWSSFont(.title1, with: alertTitle)
                $0.textColor = .wssBlack
                $0.numberOfLines = 0
                $0.textAlignment = .center
            }
        } else {
            alertTitleLabel.removeFromSuperview()
        }
        
        if let alertContent {
            alertContentLabel.do {
                $0.applyWSSFont(.body2, with: alertContent)
                $0.textColor = .wssGray300
                $0.numberOfLines = 0
                $0.textAlignment = .center
            }
        } else {
            alertContentLabel.removeFromSuperview()
            stackView.setCustomSpacing(18, after: alertTitleLabel)
        }
        
        if let cancelTitle {
            cancelButton.do {
                $0.setTitle(cancelTitle, for: .normal)
                $0.setTitleColor(.wssGray300, for: .normal)
                $0.titleLabel?.font = .Label1
                $0.layer.backgroundColor = UIColor.wssGray50.cgColor
                $0.layer.cornerRadius = 8
            }
        } else {
            cancelButton.removeFromSuperview()
            actionButton.snp.makeConstraints {
                $0.height.width.equalToSuperview()
            }
        }
        
        if let actionTitle {
            actionButton.do {
                $0.setTitle(actionTitle, for: .normal)
                $0.setTitleColor(.wssWhite, for: .normal)
                $0.titleLabel?.font = .Label1
                $0.layer.backgroundColor = actionBackgroundColor
                $0.layer.cornerRadius = 8
            }
        } else {
            actionButton.removeFromSuperview()
            cancelButton.snp.makeConstraints {
                $0.height.width.equalToSuperview()
            }
        }
    }
}
    
