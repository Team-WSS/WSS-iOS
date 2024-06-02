//
//  NormalSearchHeaderCollectionView.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 6/3/24.
//

import UIKit

import SnapKit
import Then

final class NormalSearchHeaderCollectionView: UICollectionReusableView {
    
    let titleLabel = UILabel()
    let novelResultLabel = UILabel()
    private let stackView = UIStackView()
    
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
            $0.fontTitle2Attribute(with: StringLiterals.Search.novel)
            $0.textColor = .wssBlack
        }
        
        novelResultLabel.do {
            $0.fontBody4Attribute(with: "123")
            $0.textColor = .wssGray100
        }
        
        stackView.do {
            $0.axis = .horizontal
            $0.spacing = 5
        }
    }
    
    private func setHierarchy() {
        stackView.addArrangedSubviews(titleLabel,
                                      novelResultLabel)
        self.addSubview(stackView)
    }
    
    private func setLayout() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

