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
    
    //MARK: - Components
    
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
        completeButton.do {
            $0.setText(text: StringLiterals.Onboarding.Success.completeButton)
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(completeButton)
    }
    
    private func setLayout() {
        completeButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
}

