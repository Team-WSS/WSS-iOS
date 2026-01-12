//
//  SplashView.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 7/31/25.
//

import UIKit

import SnapKit
import Then

final class SplashView: UIView {
    
    //MARK: - UI Components
    
    private let backgroundImageView = UIImageView()
    private let splashAppLogoImageView = UIImageView()
    private let splashAppTypeImageView = UIImageView()
    
    private let middleView = UIView()
    
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
        backgroundImageView.do {
            $0.image = .imgSplashBackground
        }
        
        splashAppLogoImageView.do {
            $0.image = .imgSplashIcon
            $0.contentMode = .scaleAspectFit
        }
        
        splashAppTypeImageView.do {
            $0.image = .imgSplashType
            $0.contentMode = .scaleAspectFit
        }
        
        middleView.isHidden = true
    }
    
    private func setHierarchy() {
        self.addSubview(backgroundImageView)
        backgroundImageView.addSubviews(middleView,
                                        splashAppLogoImageView,
                                        splashAppTypeImageView)
    }
    
    private func setLayout() {
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        middleView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(splashAppTypeImageView.snp.top)
            $0.centerX.equalToSuperview()
        }
        
        splashAppLogoImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(middleView.snp.centerY)
        }
        
        splashAppTypeImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(30)
        }
    }
}
