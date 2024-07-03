//
//  NormalSearchEmptyView.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/27/24.
//

import UIKit

import SnapKit
import Then

final class NormalSearchEmptyView: UIView {
    
    //MARK: - Components
    
    private let stackView = UIStackView()
    private let emptyImageView = UIImageView()
    private let descriptionLabel = UILabel()
    
    /// 작품 문의 버튼 및 버튼 내 라벨
    let inquiryButton = UIButton()
    private let inquiryButtonLabel = UILabel()
    
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
        stackView.do {
            $0.axis = .vertical
            $0.alignment = .center
            $0.spacing = 8
        }
        
        emptyImageView.do {
            $0.image = .imgEmpty
        }
        
        descriptionLabel.do {
            $0.applyWSSFont(.body1, with: StringLiterals.Search.Empty.description)
            $0.textColor = .wssGray200
            $0.numberOfLines = 2
        }
        
        inquiryButton.do {
            $0.backgroundColor = .wssPrimary50
            $0.layer.cornerRadius = 14
            
            inquiryButtonLabel.do {
                $0.applyWSSFont(.title2, with: StringLiterals.Search.Empty.inquiryButton)
                $0.textColor = .wssPrimary100
                $0.isUserInteractionEnabled = false
            }
        }
    }
    
    private func setHierarchy() {
        stackView.addArrangedSubviews(emptyImageView,
                                      descriptionLabel)
        self.addSubviews(stackView, inquiryButton)
        inquiryButton.addSubview(inquiryButtonLabel)
    }
    
    private func setLayout() {
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(252)
            $0.leading.trailing.equalToSuperview()
        }
        
        inquiryButton.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(36)
            $0.leading.trailing.equalToSuperview().inset(90)
            $0.height.equalTo(58)
            
            inquiryButtonLabel.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
        }
    }
}

