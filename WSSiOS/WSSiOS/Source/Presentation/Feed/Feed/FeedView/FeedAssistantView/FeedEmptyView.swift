//
//  FeedEmptyView.swift
//  WSSiOS
//
//  Created by 신지원 on 8/1/25.
//

import UIKit

import SnapKit
import Then

final class FeedEmptyView: UIView {
    
    //MARK: - Components
    
    private let emptyStackView = UIStackView()
    private let emptyImageView = UIImageView()
    private let emptyTitleLabel = UILabel()
    var writeFeedButton = UIButton()
    private var writeFeedButtonLabel = UILabel()
    
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
    
    //MARK: - UI
    
    private func setUI() {
        self.backgroundColor = .wssWhite
        
        emptyStackView.do {
            $0.axis = .vertical
            $0.distribution = .fill
            $0.alignment = .center
        }
        
        emptyImageView.do {
            $0.image = .imgEmpty
        }
        
        emptyTitleLabel.do {
            $0.applyWSSFont(.body1, with: StringLiterals.Feed.isEmpty)
            $0.textColor = .wssGray200
            $0.textAlignment = .center
        }
        
        writeFeedButton.do {
            $0.layer.backgroundColor = UIColor.wssPrimary50.cgColor
            $0.layer.cornerRadius = 12
        }
        
        writeFeedButtonLabel.do {
            $0.applyWSSFont(.title1, with: StringLiterals.Feed.writeFeed)
            $0.textColor = .wssPrimary100
            $0.isUserInteractionEnabled = false
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(emptyStackView)
        emptyStackView.addArrangedSubviews(emptyImageView,
                                           emptyTitleLabel,
                                           writeFeedButton)
        writeFeedButton.addSubview(writeFeedButtonLabel)
    }
    
    private func setLayout() {
        emptyStackView.snp.makeConstraints() {
            $0.edges.equalToSuperview()
        }
        
        emptyStackView.do {
            $0.setCustomSpacing(8, after: emptyImageView)
            $0.setCustomSpacing(45, after: emptyTitleLabel)
        }
        
        emptyImageView.snp.makeConstraints() {
            $0.height.equalTo(48)
        }
        
        writeFeedButton.snp.makeConstraints() {
            $0.horizontalEdges.equalToSuperview().inset(90)
            $0.height.equalTo(53)
            
            writeFeedButtonLabel.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
        }
    }
}
