//
//  HomeInterestEmptyView.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 11/13/24.
//

import UIKit

final class HomeInterestEmptyView: UIView {
    
    //MARK: - UI Components
    
    private var titleLabel = UILabel()
    
    //MARK: - Life Cycle
    
    init() {
        super.init(frame: .zero)
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        self.do {
            $0.backgroundColor = .clear
            $0.layer.cornerRadius = 14
            $0.layer.borderColor = UIColor.wssGray70.cgColor
            $0.layer.borderWidth = 1
        }
        
        titleLabel.do {
            $0.applyWSSFont(.body2, with: StringLiterals.Home.Interest.empty)
            $0.textColor = .wssGray200
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(titleLabel)
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(24)
        }
    }
}
