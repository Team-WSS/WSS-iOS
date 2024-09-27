//
//  OnboardingNickNameView.swift
//  WSSiOS
//
//  Created by YunhakLee on 9/27/24.
//

import UIKit

import SnapKit
import Then

final class OnboardingNicknameView: UIView {
    
    //MARK: - Components
    
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    let nicknameTextField = UITextField()
    private let textFieldInnerButton = UIButton()
    let duplicateCheckButton = UIButton()
    private let duplicateCheckButtonLabel = UILabel()
    private let nickNameStatusDescriptionLabel = UILabel()
    let bottomButton = OnboardingBottomButtonView()
    
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
        self.backgroundColor  = .wssWhite
        
        titleLabel.do {
            $0.applyWSSFont(.headline1, with: StringLiterals.Onboarding.NickName.title)
            $0.textColor = .wssBlack
        }
        
        descriptionLabel.do {
            $0.applyWSSFont(.body2, with: StringLiterals.Onboarding.NickName.description)
            $0.textColor = .wssGray200
        }
        
        nicknameTextField.do {
            $0.returnKeyType = .done
            $0.tintColor = .wssBlack
            $0.backgroundColor = .wssGray50
            $0.textColor = .wssBlack
            $0.placeholder = StringLiterals.Onboarding.NickName.textFieldPlaceholder
            $0.font = .Body2
            $0.layer.cornerRadius = 12
            $0.layer.borderColor = UIColor.wssGray70.cgColor
            $0.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
            $0.rightView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 44.0, height: 44.0))
            $0.leftViewMode = .always
            $0.rightViewMode = .always
        }
        
        textFieldInnerButton.do {
            $0.setImage(.icCancelDark, for: .normal)
            $0.isHidden = true
        }
        
        duplicateCheckButton.do {
            $0.backgroundColor = .wssGray70
            $0.layer.cornerRadius = 15
            $0.isEnabled = false
        }
        
        duplicateCheckButtonLabel.do {
            $0.applyWSSFont(.body2, with: StringLiterals.Onboarding.NickName.duplicateCheckButton)
            $0.textColor = .wssGray200
            $0.isUserInteractionEnabled = false
        }
        
        nickNameStatusDescriptionLabel.do {
            $0.isHidden = true
        }
        
        bottomButton.do {
            $0.setText(text: StringLiterals.Onboarding.nextButton)
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(titleLabel,
                         descriptionLabel,
                         nicknameTextField,
                         duplicateCheckButton,
                         nickNameStatusDescriptionLabel,
                         bottomButton)
        nicknameTextField.addSubview(textFieldInnerButton)
        duplicateCheckButton.addSubview(duplicateCheckButtonLabel)
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
        
        nicknameTextField.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(61)
            $0.height.equalTo(44)
            $0.leading.equalToSuperview().inset(20)
        }
        
        duplicateCheckButton.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(61)
            $0.height.equalTo(44)
            $0.leading.equalTo(nicknameTextField.snp.trailing).offset(7)
            $0.trailing.equalToSuperview().inset(20)
            $0.width.equalTo(88)
        }
        
        duplicateCheckButtonLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        nickNameStatusDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(20)
        }
        
        textFieldInnerButton.snp.makeConstraints {
            $0.verticalEdges.trailing.equalToSuperview()
            $0.size.equalTo(44)
        }
        
        bottomButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(self.keyboardLayoutGuide.snp.top)
        }
    }
    
    // MARK: - Custom Method
    
    func updateNicknameTextField(isEditing: Bool, availablity: NicknameAvailablity) {
        var borderColor: CGColor = UIColor.wssGray70.cgColor
        
        switch availablity {
        case .available:
            borderColor = UIColor.wssPrimary100.cgColor
        case .notAvailable:
            borderColor = UIColor.wssSecondary100.cgColor
        default:
            borderColor = UIColor.wssGray70.cgColor
        }
        
        nicknameTextField.do {
            $0.backgroundColor = isEditing ? .wssWhite : .wssGray50
            $0.layer.borderWidth = isEditing ? 1 : 0
            $0.layer.borderColor = borderColor
        }
    }
    
    func updateDuplicateCheckButton(isEnabled: Bool) {
        duplicateCheckButton.do {
            $0.isEnabled = isEnabled
            $0.backgroundColor = isEnabled ? .wssPrimary50 : .wssGray70
        }
        
        duplicateCheckButtonLabel.do {
            $0.textColor = isEnabled ? .wssPrimary100 : .wssGray200
        }
    }
    
    func updateTextFieldInnerButton(isEditing: Bool, availablity: NicknameAvailablity) {
        var buttonImage: UIImage = .icCancelDark
        
        switch availablity {
        case .available:
            buttonImage = .icNickNameAvailable
        case .notAvailable:
            buttonImage = .icNickNameError
        default:
            break
        }
        
        textFieldInnerButton.do {
            $0.isHidden = !isEditing
            $0.setImage(buttonImage, for: .normal)
            $0.isEnabled = !(availablity == .available) || isEditing
        }
    }
    
    func updateNickNameStatusDescriptionLabel(availablity: NicknameAvailablity) {
        let descriptionText = availablity == .available ? "사용 가능한 닉네임이에요" : "한글, 영문, 숫자 2~10자까지 입력 가능해요"
        nickNameStatusDescriptionLabel.do {
            $0.isHidden = availablity == .notStarted || availablity == .unknown
            $0.applyWSSFont(.body2, with: descriptionText)
            $0.textColor = availablity == .available ? .wssPrimary100 : .wssSecondary100
        }
    }
}

