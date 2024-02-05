//
//  RegisterNormalKeywordView.swift
//  WSSiOS
//
//  Created by 이윤학 on 1/11/24.
//

import UIKit

import SnapKit
import Then

final class RegisterNormalKeywordSelectionView: UIView {
    
    // MARK: - Components
    
    private let totalStackView = UIStackView()
    private let titleView = WSSSectionTitleView()
    
    private let keywordSelectButton = UIButton()
    private let buttonStackView = UIStackView()
    private let buttonImage = UIImageView()
    private let buttonLabel = UILabel()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    private func setUI() {
        totalStackView.do {
            $0.axis = .vertical
            $0.spacing = 18
            $0.alignment = .fill
            
            titleView.do {
                $0.setText(StringLiterals.Register.Normal.SectionTitle.keyword)
            }
            
            keywordSelectButton.do {
                $0.layer.cornerRadius = 15
                $0.layer.borderWidth = 1
                $0.layer.borderColor = UIColor.wssPrimary100.cgColor
                
                buttonStackView.do {
                    $0.axis = .horizontal
                    $0.spacing = 15
                    $0.alignment = .center
                    
                    buttonImage.do {
                        $0.image = .icPlusKeyword
                    }
                    
                    buttonLabel.do {
                        $0.text = StringLiterals.Register.Normal.Keyword.selectButton
                        buttonLabelStyle(of: $0)
                    }
                }
            }
        }
    }
    
    private func setHierarchy() {
        self.addSubview(totalStackView)
        totalStackView.addArrangedSubviews(titleView,
                                           keywordSelectButton)
        keywordSelectButton.addSubviews(buttonStackView)
        buttonStackView.addArrangedSubviews(buttonImage,
                                            buttonLabel)
    }
    
    private func setLayout() {
        totalStackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(13)
            $0.verticalEdges.equalToSuperview()
            $0.height.equalTo(43)
        }
    }
    
    // MARK: - Custom Method
    
    private func buttonLabelStyle(of label: UILabel) {
        label.do {
            $0.makeAttribute(with: label.text)?
                .lineSpacing(spacingPercentage: 150)
                .kerning(kerningPixel: -0.6)
                .applyAttribute()
            $0.font = .Body2
            $0.textColor = .wssPrimary100
        }
    }
}
