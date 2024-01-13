//
//  RegisterNormalNovelInfoStackView.swift
//  WSSiOS
//
//  Created by 이윤학 on 1/10/24.
//

import UIKit

import SnapKit
import Then

final class RegisterNormalNovelInfoView: UIView {
    
    // MARK: - UI Components
    
    private let novelInfoStackView = UIStackView()
    private let novelTitleLabel = UILabel()
    private let novelAuthorLabel = UILabel()
    
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
        novelInfoStackView.do {
            $0.axis = .vertical
            $0.spacing = 6
            $0.alignment = .center
            
            novelTitleLabel.do {
                $0.text = "여성향 게임의 파멸 플래그밖에 없는 악역 영애로 환생해 버렸다"
                novelTitleAttribute(of: $0)
            }
            
            novelAuthorLabel.do {
                $0.text = "Satoru Yamaguchi"
                novelAuthorAttribute(of: $0)
            }
        }
    }
    
    private func setHieararchy() {
        self.addSubview(novelInfoStackView)
        novelInfoStackView.addArrangedSubviews(novelTitleLabel,
                                               novelAuthorLabel)
    }
    
    private func setLayout() {
        novelInfoStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    /// novelTitle의 UI를 위한 함수.
    private func novelTitleAttribute(of label: UILabel) {
        label.do {
            $0.makeAttribute(with: label.text)?
                .lineSpacing(spacingPercentage: 140)
                .kerning(kerningPixel: -1.2)
                .applyAttribute()
            $0.font = .HeadLine1
            $0.textColor = .White
            $0.textAlignment = .center
            $0.lineBreakMode = .byTruncatingTail
            $0.lineBreakStrategy = .hangulWordPriority
            $0.numberOfLines = 3
        }
    }
    
    /// novel의 AttributedText 적용을 위한 함수.
    private func novelAuthorAttribute(of label: UILabel) {
        label.do{
            $0.makeAttribute(with: label.text)?
                .lineSpacing(spacingPercentage: 150)
                .kerning(kerningPixel: -0.6)
                .applyAttribute()
            $0.font = .Body2
            $0.textColor = .Gray200
            $0.numberOfLines = 1
            $0.lineBreakMode = .byTruncatingTail
        }
    }
}
