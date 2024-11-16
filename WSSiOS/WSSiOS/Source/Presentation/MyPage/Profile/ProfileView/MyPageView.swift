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
    
    //MARK: - Properties
    
    let isMyPage:Bool

    //MARK: - Components
    
    let scrollView = UIScrollView()
    
    let headerView = MyPageProfileHeaderView()
    let mainStickyHeaderView = UIView()
    let scrolledStstickyHeaderView = UIView()
    
    let myPageLibraryView = MyPageLibraryView(isEmpty: false)
    
    // MARK: - Life Cycle

    init(isMyPage: Bool) {
        self.isMyPage = isMyPage
        super.init(frame: .zero)
        
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
                               myPageLibraryView)
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
        
        myPageLibraryView.snp.makeConstraints {
            $0.top.equalTo(mainStickyHeaderView.snp.bottom)
            $0.width.bottom.equalToSuperview()
        }
    }
}
