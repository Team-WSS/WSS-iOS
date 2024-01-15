//
//  RegisterNormalDatePickerToolBarButton.swift
//  WSSiOS
//
//  Created by 이윤학 on 1/15/24.
//

import UIKit

import SnapKit
import Then

final class RegisterNormalDatePickerToolBarButton: UIButton {
    
    var selectedButton: Bool?
    
    // MARK: - UI Components
    
    private let buttonStackView = UIStackView()
    private let buttonTitleLabel = UILabel()
    private let buttonDateLabel = UILabel()
    
    // MARK: - Life Cycle
    
    convenience init(buttonTitle: String) {
        self.init(frame: .zero)
        
        setUI(buttonTitle: buttonTitle)
        setHieararchy()
        setLayout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: - Custom Method
    
    private func setUI(buttonTitle: String) {
        self.do {
            $0.layer.cornerRadius = self.bounds.height / 2
        }
        
        buttonStackView.do {
            $0.axis = .vertical
            $0.spacing = 2
            $0.alignment = .center
            
            buttonTitleLabel.do {
                $0.text = buttonTitle
            }
        }
    }
    
    private func setHieararchy() {
        self.addSubviews(buttonStackView)
        buttonStackView.addArrangedSubviews(buttonTitleLabel,
                                            buttonDateLabel)
    }
    
    private func setLayout() {
        buttonStackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(10)
            $0.centerX.equalToSuperview()
        }
    }
    
    func setTitle(_ text: String) {
        buttonTitleLabel.do {
            $0.text = text
            buttonTitleStyle(of: $0)
        }
    }
    
    private func buttonDateStyle(of label: UILabel) {
        label.do {
            $0.makeAttribute(with: $0.text)?
                .lineSpacing(spacingPercentage: 145)
                .applyAttribute()
            $0.font = .Label1
        }
    }
    
    private func buttonTitleStyle(of label: UILabel) {
        label.do {
            $0.makeAttribute(with: $0.text)?
                .lineSpacing(spacingPercentage: 140)
                .kerning(kerningPixel: -0.6)
                .applyAttribute()
            $0.font = .Title2
        }
    }
}
