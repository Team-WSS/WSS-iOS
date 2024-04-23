//
//  HomeRealtimePopularCell.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 4/21/24.
//

import UIKit

final class HomeRealtimePopularCell: UIView {
    
    //MARK: - UI Components
    
    private let dividerFirstView = UIView()
    private let dividerSecondView = UIView()
    private let feedFirstView = HomeRealTimePopularFeedCell()
    private let feedSecondView = HomeRealTimePopularFeedCell()
    private let feedThirdView = HomeRealTimePopularFeedCell()
    
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
        self.do {
            $0.layer.cornerRadius = 14
            $0.layer.borderColor = UIColor.Gray70.cgColor
            $0.layer.borderWidth = 1
            $0.clipsToBounds = true
        }
        
        dividerFirstView.do {
            $0.backgroundColor = .Gray70
        }
        
        dividerSecondView.do {
            $0.backgroundColor = .Gray70
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(feedFirstView,
                         dividerFirstView,
                         feedSecondView,
                         dividerSecondView,
                         feedThirdView)
    }
    
    private func setLayout() {
        feedFirstView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        dividerFirstView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(138)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        feedSecondView.snp.makeConstraints {
            $0.top.equalTo(dividerFirstView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        dividerSecondView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(138)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        feedThirdView.snp.makeConstraints {
            $0.top.equalTo(dividerSecondView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
}
