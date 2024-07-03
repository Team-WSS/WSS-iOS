//
//  HomeRealtimePopularView.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 4/20/24.
//

import UIKit

import SnapKit
import Then

final class HomeRealtimePopularView: UIView {
    
    //MARK: - UI Components
    
    private var titleLogoImageView = UIImageView()
    private var titleLabel = UILabel()
    private var titleStackView = UIStackView()
    
    private var scrollView = UIScrollView()
    
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
        titleLogoImageView.do {
            $0.image = .icTextHot
            $0.contentMode = .scaleAspectFit
        }
        
        titleLabel.do {
            $0.applyWSSFont(.headline1, with: StringLiterals.Home.Title.realtimePopular)
            $0.textColor = .wssBlack
        }
        
        titleStackView.do {
            $0.axis = .horizontal
            $0.spacing = 6
        }
    }
    
    private func setHierarchy() {
        titleStackView.addArrangedSubviews(titleLogoImageView,
                                           titleLabel)
        self.addSubview(titleStackView)
    }
    
    private func setLayout() {
        titleStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
    }
}
