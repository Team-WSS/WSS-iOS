//
//  HomeInduceDetailSearchView.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 4/29/26.
//

import UIKit

import SnapKit
import Then

final class HomeInduceDetailSearchView: UIView {
    
    //MARK: - UI Components
    
    private let imageView = UIImageView()
    
    private let labelStackView = UIStackView()
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierachy()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        self.do {
            $0.layer.cornerRadius = 14
            $0.clipsToBounds = true
            $0.backgroundColor = .wssPrimary20
        }
        
        imageView.do {
            $0.image = .imgHomeDetailSearch
            $0.contentMode = .scaleAspectFit
        }
        
        labelStackView.do {
            $0.axis = .vertical
            $0.spacing = 4
        }
        
        titleLabel.do {
            $0.applyWSSFont(.title1, with: StringLiterals.Home.Title.detailSearchBanner)
            $0.textColor = .wssBlack
        }
        
        subTitleLabel.do {
            $0.applyWSSFont(.body4, with: StringLiterals.Home.SubTitle.detailSearchBanner)
            $0.textColor = .wssGray200
        }
    }
    
    private func setHierachy() {
        self.addSubviews(imageView,
                         labelStackView)
        labelStackView.addArrangedSubviews(titleLabel,
                                           subTitleLabel)
    }
    
    private func setLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(104)
        }
        
        imageView.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(14)
        }
        
        labelStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.leading.equalToSuperview().inset(20)
        }
    }
    
    //MARK: - Custom Method
    
}

