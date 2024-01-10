//
//  RegisterNormalReadDateView.swift
//  WSSiOS
//
//  Created by 이윤학 on 1/11/24.
//

import UIKit

import SnapKit
import Then

final class RegisterNormalReadDateView: UIView {
    
    // MARK: - UI Components
    
    private let totalStackView = UIStackView()
    private let upperStackView = UIStackView()
    private let titleView = UILabel()
    private let toggle = UISwitch()
    private let datePickerView = RegisterNormalDatePickerView()
    
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
            $0.spacing = 8
            $0.alignment = .fill
        }
        
        upperStackView.do {
            $0.axis = .horizontal
            $0.spacing = 14
            $0.alignment = .center
        }
        
        titleView.do {
            $0.text = "읽기 날짜"
            titleStyle(of: $0)
        }
    }
    
    private func setHieararchy() {
        self.addSubview(totalStackView)
        totalStackView.addArrangedSubviews(upperStackView, datePickerView)
        upperStackView.addArrangedSubviews(titleView, toggle, UIView())
    }
    
    private func setLayout() {
        totalStackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
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
            $0.textColor = .Black
        }
    }
}
