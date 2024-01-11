//
//  RegisterNormalPlatformSelectButton.swift
//  WSSiOS
//
//  Created by 이윤학 on 1/11/24.
//

import UIKit

import SnapKit
import Then

final class RegisterNormalPlatformSelectButton: UIView {
    
    // MARK: - UI Components
    
    private let buttonStackView = UIStackView()
    private let buttonLabel = UILabel()
    private let buttonImage = UIImageView()
    
    // MARK: - Life Cycle
    
    convenience init(platformName: String) {
        self.init(frame: .zero)
        
        setUI(platformName: platformName)
        setHieararchy()
        setLayout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Method
    
    private func setUI(platformName: String) {
        self.do {
            $0.layer.cornerRadius = 16
            $0.backgroundColor = .Primary50
        }
        
        buttonStackView.do {
            $0.axis = .horizontal
            $0.spacing = 6
            $0.alignment = .center
        }
        
        buttonLabel.do {
            $0.text = platformName
            buttonLabelStyle(of: buttonLabel)
        }
        
        buttonImage.do {
            $0.image = ImageLiterals.icon.linkPlatform
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
        }
    }
    
    private func setHieararchy() {
        self.addSubviews(buttonStackView)
        buttonStackView.addArrangedSubviews(
            buttonLabel, buttonImage
        )
    }
    
    private func setLayout() {
        buttonStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(13)
            $0.verticalEdges.equalToSuperview().inset(7)
            
            buttonImage.snp.makeConstraints {
                $0.size.equalTo(16)
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
