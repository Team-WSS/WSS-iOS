//
//  RegisterNormalPlatformSelectButton.swift
//  WSSiOS
//
//  Created by 이윤학 on 1/11/24.
//

import UIKit

import SnapKit
import Then

final class RegisterNormalPlatformSelectButton: UIButton {
    
    // MARK: - Properties
    
    private var buttonHeigt: CGFloat = 37
    
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
    
    // MARK: - Override Method
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // touchResult
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setCornerRadius(self.frame.height/2)
    }
    
    // MARK: - Custom Method
    
    private func setUI(platformName: String) {
        self.do {
            $0.layer.cornerRadius = buttonHeigt / 2
            $0.backgroundColor = .Primary50
        }
        
        buttonStackView.do {
            $0.axis = .horizontal
            $0.spacing = 6
            $0.alignment = .center
            
            buttonLabel.do {
                $0.text = platformName
                $0.makeAttribute()?
                    .lineSpacing(spacingPercentage: 150)
                    .kerning(kerningPixel: -0.6)
                    .applyAttribute()
                $0.font = .Body2
                $0.textColor = .Primary100
            }
            
            buttonImage.do {
                $0.image = ImageLiterals.icon.linkPlatform
            }
        }
    }
    
    private func setHieararchy() {
        self.addSubviews(buttonStackView)
        buttonStackView.addArrangedSubviews(buttonLabel,
                                            buttonImage)
    }
    
    private func setLayout() {
        buttonStackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(7)
            $0.horizontalEdges.equalToSuperview().inset(13)
        }
    }
    
    private func setCornerRadius(_ radius: CGFloat) {
        self.layer.cornerRadius = radius
    }
}
