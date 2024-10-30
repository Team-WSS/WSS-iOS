//
//  DetailSearchResultEmptyView.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 10/27/24.
//

import UIKit

import SnapKit
import Then

final class DetailSearchResultEmptyView: UIView {
    
    //MARK: - UI Components
    
    private let stackView = UIStackView()
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
    
    private func setUI() {
        stackView.do {
            $0.axis = .vertical
            $0.spacing = 10
            $0.alignment = .center
        }
        
        emptyImageView.do {
            $0.image = .imgEmpty
        }
        
        emptyDescriptionLabel.do {
            $0.applyWSSFont(.body1, with: StringLiterals.DetailSearch.empty)
            $0.textColor = .wssGray200
            $0.textAlignment = .center
            $0.numberOfLines = 2
        }
    }
    
    private func setHierarchy() {
        self.addSubview(stackView)
        stackView.addArrangedSubviews(emptyImageView,
                                      emptyDescriptionLabel)
    }
    
    private func setLayout() {
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
