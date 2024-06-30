//
//  NovelDetailInfoDescriptionSection.swift
//  WSSiOS
//
//  Created by 이윤학 on 6/26/24.
//

import UIKit

import SnapKit
import Then

final class NovelDetailInfoDescriptionView: UIView {
    
    //MARK: - Properites
    
    private let basicDescriptionLineLimit: Int = 3
    private let expendedDescriptionLineLimit: Int = 0
    
    //MARK: - Components
    
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    let accordionButton = UIButton()
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
        self.addSubviews(titleLabel,
                         descriptionLabel,
                         accordionButton)
        accordionButton.addSubview(accordionImageView)
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(40)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        accordionButton.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            $0.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
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
    
    func updateAccordionButton(_ isExpended: Bool) {
        self.accordionImageView.image = isExpended ? .icChveronUp : .icChveronDown
        self.descriptionLabel.numberOfLines = isExpended ? self.expendedDescriptionLineLimit : self.basicDescriptionLineLimit
    }
    
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
