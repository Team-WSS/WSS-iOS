//
//  HomeView.swift
//  WSSiOS
//
//  Created by 최서연 on 1/9/24.
//

import UIKit

final class HomeView: UIView {
    
    //MARK: - UI Components
    
    private let homeStackView = UIStackView()
    private let headerView = HomeHeaderView()
    let characterView = HomeCharacterView()
    private let titleView = HomeSosoPickTitleView()
    let sosopickView = HomeSosoPickView()
    
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
        homeStackView.do {
            $0.axis = .vertical
        }
    }
    
    private func setHierachy() {
        self.addSubviews(homeStackView,
                         sosopickView)
        
        homeStackView.addArrangedSubviews(headerView,
                                          characterView,
                                          titleView)
    }
    
    private func setLayout() {
        homeStackView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        sosopickView.snp.makeConstraints {
            $0.top.equalTo(homeStackView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
        
        homeStackView.do {
            $0.setCustomSpacing(37, after: headerView)
            $0.setCustomSpacing(24, after: characterView)
            $0.setCustomSpacing(0, after: titleView)
        }
    }
}
