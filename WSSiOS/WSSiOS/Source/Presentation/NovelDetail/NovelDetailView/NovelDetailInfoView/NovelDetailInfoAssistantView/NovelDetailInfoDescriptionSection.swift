//
//  NovelDetailInfoDescriptionSection.swift
//  WSSiOS
//
//  Created by 이윤학 on 6/26/24.
//

import UIKit

import SnapKit
import Then

final class NovelDetailInfoDescriptionSection: UIView {
    
    //MARK: - Properites
    
    private let basicDescriptionLineLimit: Int = 3
    private let expendedDescriptionLineLimit: Int? = nil
    
    //MARK: - Components
    
    private let stackView = UIStackView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let accordionButton = UIButton()
    private let accordionImageView = UIImageView()
    
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
        self.do {
            $0.backgroundColor = .wssWhite
        }
        
        stackView.do {
            $0.axis = .vertical
            $0.alignment = .center
        }
        
        titleLabel.do {
            $0.applyWSSFont(.title1,
                            with: StringLiterals.NovelDetail.Info.description)
            $0.textColor = .wssBlack
        }
        
        accordionImageView.do {
            $0.image = .icChveronDown
            $0.isUserInteractionEnabled = false
        }
    }
    
    private func setHierarchy() {
        self.addSubview(stackView)
        stackView.addArrangedSubviews(titleLabel,
                                      descriptionLabel,
                                      accordionButton)
        accordionButton.addSubview(accordionImageView)
    }
    
    private func setLayout() {
        stackView.do {
            $0.snp.makeConstraints {
                $0.top.equalToSuperview().inset(40)
                $0.bottom.equalToSuperview()
                $0.horizontalEdges.equalToSuperview().inset(20)
            }
            
            $0.spacing = 10
        }
        
        titleLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
        }
        
        accordionButton.snp.makeConstraints {
            $0.size.equalTo(44)
        }
        
        accordionImageView.snp.makeConstraints {
            $0.top.equalTo(9.5)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(16)
        }
    }
    
    //MARK: - Data
    
    func bindData(_ data: NovelDetailInfoResult) {
        setDescriptionLabelText(with: data.novelDescription)
    }
    
    //MARK: - Custom Method
    
    private func setDescriptionLabelText(with text: String) {
        descriptionLabel.do {
            $0.applyWSSFont(.body2, with: text)
            $0.textColor = .wssGray300
            $0.textAlignment = .left
            $0.lineBreakMode = .byTruncatingTail
            $0.lineBreakStrategy = .hangulWordPriority
            $0.numberOfLines = basicDescriptionLineLimit
        }
    }
}
