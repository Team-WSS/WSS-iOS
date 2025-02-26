//
//  NovelDetailInfoDescriptionView.swift
//  WSSiOS
//
//  Created by 이윤학 on 6/26/24.
//

import UIKit

import SnapKit
import Then

final class NovelDetailInfoDescriptionView: UIView {
    
    //MARK: - Properites
    
    private let collapsedDescriptionNumberOfLines: Int = 3
    private let expandedDescriptionNumberOfLines: Int = 0
    
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
            $0.image = .icChevronDown
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
            $0.top.equalToSuperview().inset(35)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(14)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        accordionButton.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(19.5)
            $0.bottom.equalToSuperview().inset(9.5)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(44)
            $0.height.equalTo(25)
            
            accordionImageView.snp.makeConstraints {
                $0.top.equalToSuperview()
                $0.centerX.equalToSuperview()
                $0.size.equalTo(16)
            }
        }
    }
    
    //MARK: - Data
    
    func bindData(_ data: NovelDetailInfoEntity) {
        isAccordionButtonHidden(text: data.novelDescription)
        setDescriptionLabelText(with: data.novelDescription)
    }
    
    //MARK: - Custom Method
    
    func updateAccordionButton(_ isExpanded: Bool) {
        self.accordionImageView.image = isExpanded ? .icChevronUp : .icChevronDown
        self.descriptionLabel.numberOfLines = isExpanded ? self.expandedDescriptionNumberOfLines : self.collapsedDescriptionNumberOfLines
    }
    
    func isAccordionButtonHidden(text: String) {
        let textHeight = getLabelHeight(text: text)
        let threeLineHeight = getLabelHeight(text: "1\n2\n3")
        
        if textHeight <= threeLineHeight {
            accordionButton.isHidden = true
            descriptionLabel.snp.removeConstraints()
            descriptionLabel.snp.makeConstraints {
                $0.top.equalTo(titleLabel.snp.bottom).offset(14)
                $0.horizontalEdges.equalToSuperview().inset(20)
                $0.bottom.equalToSuperview().inset(40)
            }
        }
    }
    
    func getLabelHeight(text: String) -> CGFloat {
        let label = UILabel(frame: .init(x: .zero,
                                         y: .zero,
                                         width: UIScreen.main.bounds.width - 40,
                                         height: .greatestFiniteMagnitude)
        )
        label.do {
            $0.applyWSSFont(.body2, with: text)
            $0.textAlignment = .left
            $0.lineBreakStrategy = .hangulWordPriority
            $0.numberOfLines = 0
        }
        label.sizeToFit()
        let labelHeight = label.frame.height
        return labelHeight
    }
    
    private func setDescriptionLabelText(with text: String) {
        descriptionLabel.do {
            $0.applyWSSFont(.body2, with: text)
            $0.textColor = .wssGray300
            $0.textAlignment = .left
            $0.lineBreakMode = .byTruncatingTail
            $0.lineBreakStrategy = .hangulWordPriority
            $0.numberOfLines = collapsedDescriptionNumberOfLines
        }
    }
}
