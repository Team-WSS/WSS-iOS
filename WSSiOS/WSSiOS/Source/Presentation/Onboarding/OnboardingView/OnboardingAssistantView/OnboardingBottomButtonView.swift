//
//  OnboardingBottomButtonView.swift
//  WSSiOS
//
//  Created by YunhakLee on 9/27/24.
//

import UIKit

import SnapKit
import Then

final class OnboardingBottomButtonView: UIView {
    
    //MARK: - Components
    
    private let button = UIButton()
    private let buttonLabel = UILabel()
    
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
        button.do {
            $0.backgroundColor = .wssGray70
            $0.layer.cornerRadius = 14
            $0.isEnabled = false
        }
        
        buttonLabel.do {
            $0.textColor = .wssWhite
            $0.isUserInteractionEnabled = false
        }
    }
    
    private func setHierarchy() {
        self.addSubview(button)
        button.addSubview(buttonLabel)
    }
    
    private func setLayout() {
        button.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(10)
            $0.height.equalTo(53)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
       
        buttonLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    //MARK: - Data
    
    func setText(text: String) {
        buttonLabel.do {
            $0.applyWSSFont(.title1, with: text)
        }
    }
    
    func updateButtonEnabled(_ enabled: Bool) {
        button.do {
            $0.isEnabled = enabled
            $0.backgroundColor = enabled ? .wssPrimary100 : .wssGray70
        }
    }
}
