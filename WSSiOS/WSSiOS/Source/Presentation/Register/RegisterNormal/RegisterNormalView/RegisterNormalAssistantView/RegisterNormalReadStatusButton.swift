//
//  RegisterNormalCustomToggle.swift
//  WSSiOS
//
//  Created by 이윤학 on 1/11/24.
//

import UIKit

import SnapKit
import Then

final class RegisterNormalReadStatusButton: UIButton {
    
    // MARK: - Properties
    
    private var status: ReadStatus?
    private var buttonHeight: CGFloat = 37
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // UIButton 내의 StackView 터치 이벤트를 Button의 터치 이벤트로 옮겨줌.
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        return view == self.buttonStackView ? self : view
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
        self.snp.makeConstraints {
            $0.height.equalTo(buttonHeight)
        }
        buttonStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(13)
            $0.centerY.equalToSuperview()
        }

        buttonImage.snp.makeConstraints {
            $0.size.equalTo(16)
        }
    }
    
    func setText(_ text: String) {
        buttonLabel.do {
            $0.text = text
            self.buttonLabelStyle(of: $0)
        }
    }
    
    func setImage(_ image: UIImage?) {
        buttonImage.do {
            $0.image = image
        }
    }
    
    func setStatus(_ status: ReadStatus) {
        self.status = status
    }
    
    func checkStatus(_ status: ReadStatus) -> Bool {
        return self.status == status
    }
    
    func setColor(_ color: UIColor) {
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.borderColor = color.cgColor
        buttonLabel.textColor = color
    }
    
    func hideImage(_ hide: Bool) {
        buttonImage.isHidden = hide
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
