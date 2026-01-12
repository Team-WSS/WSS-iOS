//
//  OnboardingGenderButton.swift
//  WSSiOS
//
//  Created by YunhakLee on 9/28/24.
//

import UIKit

import SnapKit
import Then

final class OnboardingGenderButton: UIButton {
    
    //MARK: - Properties
    
    let gender: OnboardingGender
    
    //MARK: - Components
    
    private let buttonLabel = UILabel()
    
    //MARK: - Life Cycle
    
    init(gender: OnboardingGender) {
        self.gender = gender
        super.init(frame: .zero)
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI
    
    private func setUI() {
        self.do {
            $0.backgroundColor = .wssGray50
            $0.layer.borderColor = UIColor.wssPrimary100.cgColor
            $0.layer.cornerRadius = 8
        }
        
        buttonLabel.do {
            $0.applyWSSFont(.body2, with: gender.koreanString())
            $0.textColor = .wssGray300
            $0.isUserInteractionEnabled = false
        }
    }
    
    private func setHierarchy() {
        self.addSubview(buttonLabel)
    }
    
    private func setLayout() {
        buttonLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    // MARK: - Custom Method
    
    func updateButton(selectedGender: OnboardingGender) {
        let isSelected = selectedGender == gender
        
        self.do {
            $0.backgroundColor = isSelected ? .wssPrimary50 : .wssGray50
            $0.layer.borderWidth = isSelected ? 1 : 0
        }
        
        buttonLabel.do {
            $0.textColor = isSelected ? .wssPrimary100 : .wssGray300
        }
    }
}

