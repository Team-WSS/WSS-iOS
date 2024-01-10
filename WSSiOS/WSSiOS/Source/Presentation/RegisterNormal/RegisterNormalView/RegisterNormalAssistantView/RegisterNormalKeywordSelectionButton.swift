//
//  File.swift
//  WSSiOS
//
//  Created by 이윤학 on 1/11/24.
//

import UIKit

import SnapKit
import Then

final class RegisterNormalKeywordSelectionButton: UIView {
    
    // MARK: - UI Components
    
    private let buttonStackView = UIStackView()
    private let buttonImage = UIImageView()
    private let buttonLabel = UILabel()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHieararchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Method
    
    private func setUI() {
        self.do {
            $0.layer.cornerRadius = 15
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.Primary100.cgColor
        }
        
        buttonStackView.do {
            $0.axis = .horizontal
            $0.spacing = 15
            $0.alignment = .center
        }
        
        buttonImage.do {
            $0.image = ImageLiterals.icon.plusKeyword
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
        }
        
        buttonLabel.do {
            $0.text = "키워드 등록"
            buttonLabelStyle(of: buttonLabel)
        }
    }
    
    private func setHieararchy() {
        self.addSubviews(buttonStackView)
        buttonStackView.addArrangedSubviews(
            buttonImage, buttonLabel
        )
    }
    
    private func setLayout() {
        buttonStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(13)
            $0.centerY.equalToSuperview()
            
            buttonImage.snp.makeConstraints {
                $0.size.equalTo(24)
            }
        }
    }
    
    private func buttonLabelStyle(of label: UILabel) {
        label.do {
            $0.makeAttribute(with: label.text)?
                .lineSpacing(spacingPercentage: 150)
                .kerning(kerningPixel: -0.6)
                .applyAttribute()
            $0.font = .Body2
            $0.textColor = .Primary100
        }
    }
}
