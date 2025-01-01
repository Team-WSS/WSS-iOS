//
//  FeedDetailUnknownUserErrorView.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 12/30/24.
//

import UIKit

import SnapKit
import Then

final class FeedDetailUnknownUserErrorView: UIView {
    
    //MARK: - UI Components
    
    private let backgroundView = UIView()
    private let stackView = UIStackView()
    private let errorContentLabel = UILabel()
    let confirmationButton = UIButton()
    private let confirmationButtonLabel = UILabel()
    
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
        self.backgroundColor = .wssBlack.withAlphaComponent(0.6)
        
        backgroundView.do {
            $0.backgroundColor = .wssWhite
            $0.layer.cornerRadius = 12
        }
        
        stackView.do {
            $0.axis = .vertical
            $0.alignment = .center
            $0.spacing = 24
        }
        
        errorContentLabel.do {
            $0.applyWSSFont(.title2, with: StringLiterals.FeedDetail.notFoundFeed)
            $0.textColor = .wssBlack
        }
        
        confirmationButton.do {
            $0.layer.backgroundColor = UIColor.wssGray70.cgColor
            $0.layer.cornerRadius = 8
        }
        
        confirmationButtonLabel.do {
            $0.isUserInteractionEnabled = false
            $0.applyWSSFont(.body4, with: StringLiterals.FeedDetail.confirm)
            $0.textColor = .wssGray300
        }
    }
    
    private func setHierarchy() {
        self.addSubview(backgroundView)
        backgroundView.addSubview(stackView)
        stackView.addArrangedSubviews(errorContentLabel,
                                      confirmationButton)
        confirmationButton.addSubview(confirmationButtonLabel)
    }
    
    private func setLayout() {
        backgroundView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(41.5)
        }
        
        stackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(24)
            $0.horizontalEdges.equalToSuperview().inset(29)
        }
        
        confirmationButton.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        confirmationButtonLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
