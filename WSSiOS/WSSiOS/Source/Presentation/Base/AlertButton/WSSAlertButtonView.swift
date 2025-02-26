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
    var leftButton = UIButton()
    var leftButtonTitleLabel = UILabel()
    var rightButton = UIButton()
    var rightButtonTitleLabel = UILabel()
    
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
        buttonStackView.addArrangedSubviews(leftButton,
                                            rightButton)
        leftButton.addSubview(leftButtonTitleLabel)
        rightButton.addSubview(rightButtonTitleLabel)
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
            $0.setCustomSpacing(10, after: alertTitleLabel)
            $0.setCustomSpacing(24, after: alertContentLabel)
        }
        
        alertImageView.snp.makeConstraints {
            $0.size.equalTo(46)
        }
        
        buttonStackView.do {
            $0.snp.makeConstraints {
                $0.width.equalToSuperview()
                $0.height.equalTo(40)
            }
        }
        
        [leftButton, rightButton].forEach { button in
            button.snp.makeConstraints {
                $0.height.equalToSuperview()
            }
        }
        
        [leftButtonTitleLabel, rightButtonTitleLabel].forEach { label in
            label.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
        }
    }
}

extension WSSAlertButtonView {
    func updateLayout(alertImage: UIImage?,
                      alertTitle: String?,
                      alertContent: String?,
                      leftTitle: String?,
                      rightTitle: String?,
                      rightBackgroundColor: CGColor?) {
        
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
        
        if let leftTitle {
            leftButton.do {
                $0.layer.backgroundColor = UIColor.wssGray50.cgColor
                $0.layer.cornerRadius = 8
            }
            
            leftButtonTitleLabel.do {
                $0.isUserInteractionEnabled = false
                $0.applyWSSFont(.label1, with: leftTitle)
                $0.textColor = .wssGray300
            }
            
        } else {
            leftButton.removeFromSuperview()
            rightButton.snp.makeConstraints {
                $0.height.width.equalToSuperview()
            }
        }
        
        if let rightTitle {
            rightButton.do {
                $0.layer.backgroundColor = rightBackgroundColor
                $0.layer.cornerRadius = 8
            }
            
            rightButtonTitleLabel.do {
                $0.isUserInteractionEnabled = false
                $0.applyWSSFont(.label1, with: rightTitle)
                $0.textColor = .wssWhite
            }
            
        } else {
            rightButton.removeFromSuperview()
            leftButton.snp.makeConstraints {
                $0.height.width.equalToSuperview()
            }
        }
    }
}
    
