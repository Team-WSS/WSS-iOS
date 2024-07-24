//
//  MyPageDeleteIDRecordView.swift
//  WSSiOS
//
//  Created by 신지원 on 7/24/24.
//

import UIKit

import SnapKit
import Then

final class MyPageDeleteIDRecordView: UIView {
    
    //MARK: - Components
    
    private let stackView = UIStackView()
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let countLabel = UILabel()
    
    
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
        
        stackView.do {
            $0.axis = .vertical
            $0.alignment = .center
            $0.contentMode = .scaleAspectFit
            $0.backgroundColor = .wssPrimary20
            $0.layer.cornerRadius = 14
        }
        
        titleLabel.do {
            $0.textColor = .wssGray300
        }
        
        countLabel.do {
            $0.textColor = .wssBlack
        }
    }
    
    private func setHierarchy() {
        self.addSubview(stackView)
        stackView.addArrangedSubviews(iconImageView,
                                      titleLabel,
                                      countLabel)
    }
    
    private func setLayout() {
        stackView.snp.makeConstraints {
            $0.center.width.equalToSuperview()
        }
        
        stackView.do {
            $0.isLayoutMarginsRelativeArrangement = true
            $0.directionalLayoutMargins.top = 20
            $0.directionalLayoutMargins.bottom = 20
            $0.setCustomSpacing(5, after: iconImageView)
        }
        
        iconImageView.snp.makeConstraints {
            $0.size.equalTo(25)
        }
        
        countLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(20)
        }
    }
    
    //MARK: - Data
    
    func bindData(icon: UIImage, status: String, count: String) {
        iconImageView.image = icon
        titleLabel.applyWSSFont(.title3, with: status)
        countLabel.applyWSSFont(.title2, with: count)
    }
}

