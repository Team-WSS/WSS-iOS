//
//  HomeHeaderView.swift
//  WSSiOS
//
//  Created by 최서연 on 1/9/24.
//

import UIKit

import SnapKit
import Then

final class HomeHeaderView: UIView {
    
    //MARK: - UI Components
    
    private let logoImageView = UIImageView()
    private let headerSearchView = HomeSearchButtonView()
    
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
        logoImageView.do {
            $0.image = ImageLiterals.icon.imgLogoType
        }
    }
    
    private func setHierachy() {
        self.addSubviews(logoImageView, headerSearchView)
    }
    
    private func setLayout() {
        logoImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(2)
            $0.leading.bottom.equalToSuperview()
        }
        
        headerSearchView.snp.makeConstraints {
            $0.top.trailing.equalToSuperview()
            $0.leading.equalTo(logoImageView.snp.trailing).offset(17)
            $0.bottom.equalTo(logoImageView.snp.bottom).offset(2)
        }
    }
}
