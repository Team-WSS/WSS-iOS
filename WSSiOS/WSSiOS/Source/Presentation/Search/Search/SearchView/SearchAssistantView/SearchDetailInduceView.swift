//
//  SearchDetailInduceView.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/26/24.
//

import UIKit

import SnapKit
import Then

final class SearchDetailInduceView: UIView {
    
    //MARK: - Components
    
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let backgroundImageView = UIImageView()
    
    /// 상세 탐색 버튼 및 버튼 내 라벨
    let induceDetailButtonView = UIView()
    private let induceDetailButtonLabel = UILabel()
    
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
        self.do {
            $0.backgroundColor = .wssPrimary20
            $0.layer.cornerRadius = 14
        }
        
        titleLabel.do {
            $0.applyWSSFont(.title1, with: StringLiterals.Search.induceTitle)
            $0.textColor = .wssBlack
        }
        
        descriptionLabel.do {
            $0.applyWSSFont(.label1, with: StringLiterals.Search.induceDescription)
            $0.textColor = .wssGray200
        }
        
        backgroundImageView.do {
            $0.image = .imgInduceSearchDetail
            $0.contentMode = .scaleAspectFill
        }
        
        induceDetailButtonView.do {
            $0.backgroundColor = .wssWhite
            $0.layer.cornerRadius = 14
            $0.clipsToBounds = true
        }
        
        induceDetailButtonLabel.do {
            $0.applyWSSFont(.title3, with: StringLiterals.Search.induceButton)
            $0.textColor = .wssPrimary100
            $0.isUserInteractionEnabled = false
        }
    }
    
    private func setHierarchy() {
        self.addSubview(backgroundImageView)
        backgroundImageView.addSubviews(titleLabel,
                                        descriptionLabel,
                                        induceDetailButtonView)
        induceDetailButtonView.addSubview(induceDetailButtonLabel)
    }
    
    private func setLayout() {
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.leading.equalToSuperview().inset(20)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.equalTo(titleLabel.snp.leading)
        }
        
        induceDetailButtonView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(113)
            $0.leading.trailing.equalToSuperview().inset(22.5)
            $0.bottom.equalToSuperview().inset(21)
            
            induceDetailButtonLabel.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
        }
    }
}
