//
//  NovelInfoWithRatingView.swift
//  WSSiOS
//
//  Created by 이윤학 on 1/7/24.
//

import UIKit

import SnapKit
import Then

final class RegisterNormalNovelInfoWithRatingView: UIView {
    
    // MARK: - UI Components
    
    private let novelInfoWithRatingContentView = UIStackView()
    private let novelInfoStackView = RegisterNormalNovelInfoStackView()
    
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
        novelInfoWithRatingContentView.do {
            $0.axis = .vertical
            $0.spacing = 22
            $0.alignment = .center
        }
    }
    
    private func setHieararchy() {
        self.addSubview(novelInfoWithRatingContentView)
        
        novelInfoWithRatingContentView.addArrangedSubviews(
            novelInfoStackView
        )
    }
    
    private func setLayout() {
        novelInfoWithRatingContentView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(67)
            $0.verticalEdges.equalToSuperview()
        }
    }
}
