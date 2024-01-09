//
//  HomeView.swift
//  WSSiOS
//
//  Created by 최서연 on 1/9/24.
//

import UIKit

final class HomeView: UIView {
    
    //MARK: - UI Components
    
    private let headerView = HomeHeaderView()
    private let characterView = HomeCharacterView()
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setHierachy()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setHierachy() {
        self.addSubviews(headerView,
                         characterView)
    }
    
    private func setLayout() {
        headerView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(14)
            $0.leading.equalToSuperview().inset(20)
            $0.centerX.equalToSuperview()
        }
        
        characterView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(37)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
}
