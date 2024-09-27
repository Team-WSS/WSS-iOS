//
//  MyPageView.swift
//  WSSiOS
//
//  Created by 신지원 on 1/8/24.
//

import UIKit

import Kingfisher
import SnapKit
import Then

final class MyPageView: UIView {
    
    //MARK: - Components
    
    let scrollView = UIScrollView()
    
    let headerView = MyPageProfileHeaderView()
    let mainStickyHeaderView = UIView()
    let scrolledStstickyHeaderView = UIView()
    
    let dummyView = UIView().then {
        $0.backgroundColor = .wssGray70
    }

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
        self.backgroundColor = .wssPrimary20
        
        mainStickyHeaderView.do {
            $0.backgroundColor = .wssPrimary100
        }
        
        scrolledStstickyHeaderView.do {
            $0.backgroundColor = .wssPrimary100
            $0.isHidden = true
        }
    }
    
    private func setHierarchy() {
        addSubviews(scrollView,
                    scrolledStstickyHeaderView)
        
        scrollView.addSubviews(headerView,
                               mainStickyHeaderView,
                               dummyView)
    }
    
    private func setLayout() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.left.right.bottom.equalToSuperview()
        }
        
        headerView.snp.makeConstraints {
            $0.top.width.equalToSuperview()
        }
        
        mainStickyHeaderView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.width.equalToSuperview()
            $0.height.equalTo(47)
        }
        
        scrolledStstickyHeaderView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.width.equalToSuperview()
            $0.height.equalTo(47)
        }
        
        dummyView.snp.makeConstraints {
            $0.top.equalTo(mainStickyHeaderView.snp.bottom)
            $0.width.equalToSuperview()
            $0.height.equalTo(1000)
            $0.bottom.equalToSuperview()
        }
    }
}
