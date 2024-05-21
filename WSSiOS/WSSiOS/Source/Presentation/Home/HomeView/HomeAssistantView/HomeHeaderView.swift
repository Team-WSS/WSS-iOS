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
    private let announcementImageView = UIImageView()
    
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
            $0.image = .imgLogoType
        }
        
        announcementImageView.do {
            $0.image = .icAnnouncementDotted
        }
    }
    
    private func setHierachy() {
        self.addSubviews(logoImageView,
                         announcementImageView)
    }
    
    private func setLayout() {
        logoImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().inset(20)
        }
        
        announcementImageView.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.top)
            $0.trailing.equalToSuperview().inset(20)
        }
    }
}
