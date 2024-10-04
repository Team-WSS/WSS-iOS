//
//  OnboardingSuccessView.swift
//  WSSiOS
//
//  Created by YunhakLee on 10/4/24.
//

import UIKit

import Lottie
import SnapKit
import Then

final class OnboardingSuccessView: UIView {
    
    //MARK: - Properties
    
    private let lottieSize: CGFloat = UIScreen.main.bounds.width - 75
    
    //MARK: - Components
    
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let lottieView = Lottie.Onboarding.success
    let completeButton = OnboardingBottomButtonView()
    
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
            $0.applyWSSFont(.headline1, with: StringLiterals.Onboarding.Success.title)
            $0.textColor = .wssBlack
        }
        
        descriptionLabel.do {
            $0.applyWSSFont(.body2, with: StringLiterals.Onboarding.Success.description(name: "테스트"))
            $0.textColor = .wssGray300
        }
        
        lottieView.do {
            $0.play()
        }
        
        completeButton.do {
            $0.setText(text: StringLiterals.Onboarding.Success.completeButton)
            $0.updateButtonEnabled(true)
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(titleLabel,
                         descriptionLabel,
                         lottieView,
                         completeButton)
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(descriptionLabel.snp.top).offset(-10)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(lottieView.snp.top).offset(-35)
        }
        
        lottieView.snp.makeConstraints {
            $0.size.equalTo(lottieSize)
            $0.centerX.equalToSuperview().offset(11)
            $0.centerY.equalToSuperview().offset(-8)
        }
        
        completeButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
}

