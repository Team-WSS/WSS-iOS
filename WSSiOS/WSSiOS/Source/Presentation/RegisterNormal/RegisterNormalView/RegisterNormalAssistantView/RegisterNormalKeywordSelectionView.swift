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
    
    // MARK: - UI Components
    
    private let totalStackView = UIStackView()
    private let titleView = UILabel()
    private let keywordButtonView = RegisterNormalKeywordSelectionButton()
    
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
        totalStackView.do {
            $0.axis = .vertical
            $0.spacing = 18
            $0.alignment = .fill
        }
        
        titleView.do {
            $0.text = "키워드"
            titleStyle(of: $0)
        }
    }
    
    private func setHieararchy() {
        self.addSubview(totalStackView)
        totalStackView.addArrangedSubviews(titleView, keywordButtonView)
    }
    
    private func setLayout() {
        totalStackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        keywordButtonView.snp.makeConstraints {
            $0.height.equalTo(43)
        }
    }
    
    private func titleStyle(of label: UILabel) {
        label.do {
            $0.makeAttribute(with: label.text)?
                .lineSpacing(spacingPercentage: 140)
                .kerning(kerningPixel: -0.6)
                .partialColor(color: .Secondary100, rangeString: "*")
                .applyAttribute()
            $0.font = .Title1
        }
    }
}
