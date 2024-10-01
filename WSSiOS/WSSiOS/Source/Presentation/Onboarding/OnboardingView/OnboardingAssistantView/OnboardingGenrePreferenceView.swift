//
//  OnboardingGenrePreferenceView.swift
//  WSSiOS
//
//  Created by YunhakLee on 10/1/24.
//

import UIKit

import SnapKit
import Then

final class OnboardingGenrePreferenceView: UIView {
    
    //MARK: - Components
    
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let skipButton = UIButton()
    
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
        
        skipButton.do {
            $0.setTitle(StringLiterals.Onboarding.GenrePreference.skipButton,
                        for: .normal)
            $0.titleLabel?.applyWSSFont(.body2, with: StringLiterals.Onboarding.GenrePreference.skipButton)
        }
        
        titleLabel.do {
            $0.applyWSSFont(.headline1, with: StringLiterals.Onboarding.GenrePreference.title)
            $0.textColor = .wssBlack
        }
        
        descriptionLabel.do {
            $0.applyWSSFont(.body2, with: StringLiterals.Onboarding.GenrePreference.description)
            $0.textColor = .wssGray200
        }
        
        bottomButton.do {
            $0.setText(text: StringLiterals.Onboarding.GenrePreference.completeButton)
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(titleLabel,
                         descriptionLabel,
                         bottomButton)
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
        
        bottomButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(self.keyboardLayoutGuide.snp.top)
        }
    }
    
    // MARK: - Custom Method
    
}

