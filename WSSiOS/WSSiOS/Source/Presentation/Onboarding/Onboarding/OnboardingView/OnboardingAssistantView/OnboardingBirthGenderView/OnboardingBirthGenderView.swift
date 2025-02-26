//
//  OnboardingBirthGenderView.swift
//  WSSiOS
//
//  Created by YunhakLee on 9/28/24.
//

import UIKit

import SnapKit
import Then

final class OnboardingBirthGenderView: UIView {
    
    //MARK: - Components
    
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    private let genderTitleLabel = UILabel()
    private let genderButtonStackView = UIStackView()
    let genderButtons = OnboardingGender.allCases.map { OnboardingGenderButton(gender: $0) }
    
    private let birthTitleLabel = UILabel()
    let selectBirthButton = UIButton()
    private let selectedBirthLabel = UILabel()
    private let selectBirthButtonImageView = UIImageView()
    
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
        self.backgroundColor = .wssWhite
        
        titleLabel.do {
            $0.applyWSSFont(.headline1, with: StringLiterals.Onboarding.BirthGender.title)
            $0.textColor = .wssBlack
        }
        
        descriptionLabel.do {
            $0.applyWSSFont(.body2, with: StringLiterals.Onboarding.BirthGender.description)
            $0.textColor = .wssGray200
        }
        
        genderTitleLabel.do {
            $0.applyWSSFont(.body2, with: StringLiterals.Onboarding.BirthGender.genderTitle)
            $0.textColor = .wssBlack
        }
        
        genderButtonStackView.do {
            $0.axis = .horizontal
            $0.spacing = 13
            $0.distribution = .fillEqually
            $0.alignment = .fill
        }
        
        birthTitleLabel.do {
            $0.applyWSSFont(.body2, with: StringLiterals.Onboarding.BirthGender.birthTitle)
            $0.textColor = .wssBlack
        }
        
        selectBirthButton.do {
            $0.backgroundColor = .wssGray50
            $0.layer.cornerRadius = 8
        }
        
        selectedBirthLabel.do {
            $0.applyWSSFont(.body2, with: StringLiterals.Onboarding.BirthGender.birthPlaceholder)
            $0.textColor = .wssGray200
            $0.isUserInteractionEnabled = false
        }
        
        selectBirthButtonImageView.do {
            $0.image = .icChevronDown
            $0.contentMode = .scaleAspectFit
            $0.isUserInteractionEnabled = false
        }
        
        bottomButton.do {
            $0.setText(text: StringLiterals.Onboarding.nextButton)
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(titleLabel,
                         descriptionLabel,
                         genderTitleLabel,
                         genderButtonStackView,
                         birthTitleLabel,
                         selectBirthButton,
                         bottomButton)
        genderButtons.forEach { genderButtonStackView.addArrangedSubview($0) }
        selectBirthButton.addSubviews(selectedBirthLabel,
                                      selectBirthButtonImageView)
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(50)
            $0.leading.equalToSuperview().inset(20)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        genderTitleLabel.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(50)
            $0.leading.equalToSuperview().inset(20)
        }
        
        genderButtonStackView.snp.makeConstraints {
            $0.top.equalTo(genderTitleLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(43)
        }
        
        birthTitleLabel.snp.makeConstraints {
            $0.top.equalTo(genderButtonStackView.snp.bottom).offset(40)
            $0.leading.equalToSuperview().inset(20)
        }
        
        selectBirthButton.snp.makeConstraints {
            $0.top.equalTo(birthTitleLabel.snp.bottom).offset(6)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(43)
        }
        
        selectedBirthLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
        
        selectBirthButtonImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
            $0.size.equalTo(16)
        }
        
        bottomButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(self.keyboardLayoutGuide.snp.top)
        }
    }
    
    // MARK: - Custom Method
    
    func updateGenderButton(selectedGender: OnboardingGender) {
        genderButtons.forEach {
            $0.updateButton(selectedGender: selectedGender)
        }
    }
    
    func updateBirthLabel(selectedBirth: Int?) {
        if let selectedBirth {
            selectedBirthLabel.do {
                $0.applyWSSFont(.body2, with: "\(String(describing: selectedBirth))")
                $0.textColor = .wssBlack
            }
        } else {
            selectedBirthLabel.do {
                $0.applyWSSFont(.body2, with: StringLiterals.Onboarding.BirthGender.birthPlaceholder)
                $0.textColor = .wssGray200
            }
        }
    }
}

