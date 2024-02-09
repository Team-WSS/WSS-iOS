//
//  WSSSectionTitleView.swift
//  WSSiOS
//
//  Created by 이윤학 on 1/13/24.
//

import UIKit

import SnapKit
import Then

final class WSSSectionTitleView: UIView {

    // MARK: - UI Components
    
    private let titleLabel = UILabel()
    
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
        titleLabel.do {
            titleStyle(of: $0)
        }
    }
    
    private func setHierarchy() {
        self.addSubview(titleLabel)
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setText(_ text: String?) {
        titleLabel.text = text
        setUI()
    }
    
    private func titleStyle(of label: UILabel) {
        label.do {
            $0.textColor = .Black
            $0.makeAttribute(with: label.text)?
                .lineSpacing(spacingPercentage: 140)
                .kerning(kerningPixel: -0.6)
                .partialColor(color: .Secondary100, rangeString: "*")
                .applyAttribute()
            $0.font = .Title1
        }
    }
}
