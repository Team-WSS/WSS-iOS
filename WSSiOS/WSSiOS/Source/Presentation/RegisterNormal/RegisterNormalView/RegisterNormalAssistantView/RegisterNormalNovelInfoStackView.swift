//
//  RegisterNormalNovelInfoStackView.swift
//  WSSiOS
//
//  Created by 이윤학 on 1/10/24.
//

import UIKit

import SnapKit
import Then

final class RegisterNormalNovelInfoStackView: UIView {
    
    // MARK: - UI Components
    
    private let novelInfoStackView = UIStackView()
    private let novelTitleLabel = UILabel()
    private let novelAuthorLabel = UILabel()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setHieararchy()
        setUI()
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
        }
        
        novelTitleLabel.do {
            $0.text = "여성향 게임의 파멸 플래그밖에 없는 악역 영애로 환생해 버렸다"
            //$0.setLineSpacingAndKerning(spacingPercentage: 140, kerningPixel: -1.2)
            $0.font = .HeadLine1
            $0.textColor = .White
            $0.numberOfLines = 3
            $0.textAlignment = .center
            $0.lineBreakMode = .byTruncatingTail
            $0.lineBreakStrategy = .hangulWordPriority
        }
        
        novelAuthorLabel.do {
            
            $0.text = "Satoru Yamaguchi"
            //$0.setLineSpacingAndKerning(spacingPercentage: 150, kerningPixel: -0.6)
            $0.font = .Body2
            $0.textColor = .Gray200
            $0.numberOfLines = 1
            $0.lineBreakMode = .byTruncatingTail
        }
    }
    
    private func setHieararchy() {
        self.addSubview(novelInfoStackView)

        novelInfoStackView.addArrangedSubviews(
            novelTitleLabel, novelAuthorLabel
        )
    }
    
    private func setLayout() {
        novelInfoStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
}
