//
//  OnboardingNickNameView.swift
//  WSSiOS
//
//  Created by YunhakLee on 9/27/24.
//

import UIKit

import SnapKit
import Then

final class OnboardingNickNameView: UIView {
    
    //MARK: - Components
    
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let nickNameTextField = UITextField()
    private let textFieldInnerButton = UIButton()
    private let duplicateCheckButton = UIButton()
    private let dubplicateCheckButtonLabel = UILabel()
    
    //MARK: - Life Cycle
    
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
        titleLabel.do {
            $0.applyWSSFont(.headline1, with: StringLiterals.Onboarding.NickName.title)
            $0.textColor = .wssBlack
        }
        
        descriptionLabel.do {
            $0.applyWSSFont(.body2, with: StringLiterals.Onboarding.NickName.description)
            $0.textColor = .wssGray200
        }
        
        nickNameTextField.do {
            $0.returnKeyType = .done
            $0.tintColor = .wssBlack
            $0.backgroundColor = .wssGray50
            $0.textColor = .wssBlack
            $0.placeholder = StringLiterals.Onboarding.NickName.textFieldPlaceholder
            $0.font = .Body2
            $0.layer.cornerRadius = 12
            $0.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
            $0.rightView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 44.0, height: 44.0))
            $0.leftViewMode = .always
            $0.rightViewMode = .whileEditing
        }
        
        textFieldInnerButton.do {
            $0.setImage(.icCancelDark, for: .normal)
        }
        
        duplicateCheckButton.do {
            $0.backgroundColor = .wssGray70
            $0.layer.cornerRadius = 15
        }
        
        dubplicateCheckButtonLabel.do {
            $0.applyWSSFont(.body2, with: StringLiterals.Onboarding.NickName.duplicateCheckButton)
            $0.textColor = .wssGray200
            $0.isUserInteractionEnabled = false
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(titleLabel,
                         descriptionLabel,
                         nickNameTextField,
                         duplicateCheckButton)
        nickNameTextField.addSubview(textFieldInnerButton)
        duplicateCheckButton.addSubview(dubplicateCheckButtonLabel)
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(50)
            $0.leading.equalToSuperview().inset(20)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().inset(20)
        }
        
        nickNameTextField.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(61)
            $0.height.equalTo(44)
            $0.leading.equalToSuperview().inset(20)
        }
        
        duplicateCheckButton.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(61)
            $0.height.equalTo(44)
            $0.leading.equalTo(nickNameTextField.snp.trailing).offset(7)
            $0.trailing.equalToSuperview().inset(20)
            $0.width.equalTo(88)
        }
    }
}

