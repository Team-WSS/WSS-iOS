//
//  NormalSearchResultCountView.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 6/23/24.
//

import UIKit

import SnapKit
import Then

final class NormalSearchResultCountView: UIView {
    
    private let titleLabel = UILabel()
    let novelCountLabel = UILabel()
    let noSearchResultLabel = UILabel()
    private let leftStackView = UIStackView()
    private let mainStackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        titleLabel.do {
            $0.applyWSSFont(.title2, with: StringLiterals.Search.novel)
            $0.textColor = .wssBlack
        }
        
        novelCountLabel.do {
            $0.textColor = .wssGray100
        }
        
        noSearchResultLabel.do {
            $0.applyWSSFontWithUnderLine(.body4, with: StringLiterals.Search.noSearchResult)
            $0.textColor = .wssGray200
        }
        
        leftStackView.do {
            $0.axis = .horizontal
            $0.spacing = 5
            $0.alignment = .center
        }
        
        mainStackView.do {
            $0.axis = .horizontal
            $0.distribution = .equalSpacing
            $0.alignment = .center
        }
    }
    
    private func setHierarchy() {
        leftStackView.addArrangedSubviews(titleLabel,
                                          novelCountLabel)
        mainStackView.addArrangedSubviews(leftStackView,
                                          noSearchResultLabel)
        self.addSubview(mainStackView)
    }
    
    private func setLayout() {
        mainStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func bindData(data: Int) {
        novelCountLabel.applyWSSFont(.body4, with: String(describing: data))
    }
}
