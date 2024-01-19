//
//  HomeView.swift
//  WSSiOS
//
//  Created by 최서연 on 1/9/24.
//

import UIKit

final class HomeView: UIView {
    
    //MARK: - UI Components
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    let headerView = HomeHeaderView()
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
        scrollView.do {
            $0.showsVerticalScrollIndicator = false
        }
    }
    
    private func setHierachy() {
        self.addSubviews(headerView,
                        scrollView)
        self.scrollView.addSubview(contentView)
        contentView.addSubviews(characterView,
                                          titleView,
                                          sosopickView)
    }
    
    private func setLayout() {
        headerView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
        
        contentView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(15)
            $0.leading.trailing.bottom.width.equalToSuperview()
        }
        
        characterView.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
        }
        
        titleView.snp.makeConstraints {
            if UIScreen.main.bounds.height < 813 {
                $0.top.equalTo(characterView.snp.bottom).offset(24)
            } else {
                $0.top.equalTo(characterView.snp.bottom).offset(((UIScreen.main.bounds.height-812))/2+24)
            }
            $0.centerX.leading.trailing.equalToSuperview()
        }
        
        sosopickView.snp.makeConstraints {
          
            $0.top.equalTo(titleView.snp.bottom)
            $0.centerX.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(230)
        }
    }
}
