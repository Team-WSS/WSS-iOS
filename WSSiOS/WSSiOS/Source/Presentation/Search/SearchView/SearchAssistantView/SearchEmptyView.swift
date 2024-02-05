//
//  SearchEmptyView.swift
//  WSSiOS
//
//  Created by 최서연 on 1/6/24.
//

import UIKit

import SnapKit
import Then

final class SearchEmptyView: UIView {
    
    //MARK: - Components
    
    private let emptyImageView = UIImageView()
    private let emptyDescriptionLabel = UILabel()
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI
    
    private func setUI() {
        emptyImageView.do {
            $0.image = .icBookRegistrationNoresult
        }
        
        emptyDescriptionLabel.do {
            $0.text = StringLiterals.Search.empty
            $0.font = .Body1
            $0.textColor = .wssGray200
        }
    }

    private func setHierarchy() {
        self.addSubviews(emptyImageView,
                         emptyDescriptionLabel)
        
    }

    private func setLayout() {
        emptyImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(191)
            $0.centerX.equalToSuperview()
        }
        
        emptyDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(emptyImageView.snp.bottom).offset(9)
            $0.centerX.equalToSuperview()
        }
    }
}
