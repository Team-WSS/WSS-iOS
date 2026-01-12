//
//  WSSNetworkErrorView.swift
//  WSSiOS
//
//  Created by YunhakLee on 11/4/24.
//

import UIKit

import SnapKit
import Then

final class WSSNetworkErrorView: UIView {
    
    // MARK: - UI Components
    
    private let stackView = UIStackView()
    private let errorImageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    let refreshButton = UIButton()
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
    
    // MARK: - Custom Method
    
    private func setUI() {
        self.do {
            $0.backgroundColor = .wssWhite
        }
        
        stackView.do {
            $0.axis = .vertical
            $0.alignment = .center
        }
        
        errorImageView.do {
            $0.image = .imgEmptyCatQuestionmark
            $0.contentMode = .scaleAspectFit
        }
        
        titleLabel.do {
            $0.applyWSSFont(.title1, with: StringLiterals.Error.title)
            $0.textColor = .wssBlack
            $0.textAlignment = .center
            $0.numberOfLines = 2
        }
        
        descriptionLabel.do {
            $0.applyWSSFont(.body2, with: StringLiterals.Error.description)
            $0.textColor = .wssGray300
            $0.textAlignment = .center
            $0.numberOfLines = 2
        }
        
        refreshButton.do {
            $0.backgroundColor = .wssPrimary100
            $0.layer.cornerRadius = 8
        }
        
        buttonLabel.do {
            $0.applyWSSFont(.label1, with: StringLiterals.Error.refreshButton)
            $0.textColor = .wssWhite
            $0.isUserInteractionEnabled = false
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(stackView)
        stackView.addArrangedSubviews(errorImageView,
                                      titleLabel,
                                      descriptionLabel,
                                      refreshButton)
        refreshButton.addSubview(buttonLabel)
    }
    
    private func setLayout() {
        stackView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.centerY.equalToSuperview()            
            stackView.do {
                $0.setCustomSpacing(41, after: errorImageView)
                $0.setCustomSpacing(10, after: titleLabel)
                $0.setCustomSpacing(41, after: descriptionLabel)
            }
        }
        
        errorImageView.snp.makeConstraints {
            $0.width.equalTo(166)
            $0.height.equalTo(160)
        }
        
        refreshButton.snp.makeConstraints {
            $0.width.equalTo(178)
            $0.height.equalTo(47)
            
            buttonLabel.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
        }
    }
}
