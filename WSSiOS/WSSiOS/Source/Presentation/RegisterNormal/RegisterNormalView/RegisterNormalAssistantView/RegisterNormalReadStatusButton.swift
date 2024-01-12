//
//  RegisterNormalCustomToggle.swift
//  WSSiOS
//
//  Created by 이윤학 on 1/11/24.
//

import UIKit

import SnapKit
import Then

class RegisterNormalReadStatusButton: UIButton {
    
    // MARK: - Properties
    
    // 각 View의 Size
    typealias SizeSet = (width: CGFloat, height: CGFloat)
    
    private var buttonHeight: CGFloat = 37
    private var buttonImageSize = SizeSet(width: 16, height: 16)
    
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
            $0.layer.cornerRadius = buttonHeight / 2
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.Primary100.cgColor
        }
        
        buttonStackView.do {
            $0.axis = .horizontal
            $0.spacing = 6
            $0.alignment = .center
            
            buttonImage.do {
                $0.contentMode = .scaleAspectFill
                $0.clipsToBounds = true
            }
            
            buttonLabel.do {
                buttonLabelStyle(of: $0)
            }
        }
    }
    
    private func setHieararchy() {
        self.addSubviews(buttonStackView)
        buttonStackView.addArrangedSubviews(buttonImage,
                                            buttonLabel)
    }
    
    private func setLayout() {
        buttonStackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(7)
            $0.horizontalEdges.equalToSuperview().inset(13)
            
            buttonImage.snp.makeConstraints {
                $0.size.equalTo(buttonImageSize.height)
            }
        }
    }
    
    func setText(_ text: String) {
        buttonLabel.do {
            $0.text = text
            self.buttonLabelStyle(of: $0)
        }
    }
    
    func setImage(_ image: UIImage) {
        buttonImage.do {
            $0.image = image
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
