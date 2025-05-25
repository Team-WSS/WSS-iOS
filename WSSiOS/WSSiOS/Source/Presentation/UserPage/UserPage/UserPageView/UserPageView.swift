//
//  UserPageView.swift
//  WSSiOS
//
//  Created by 신지원 on 1/8/24.
//

import UIKit

import SnapKit
import Then

final class UserPageView: UIView {
    
    //MARK: - Components
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let headerView = UserPageProfileHeaderView()
    let mainStickyHeaderView = UserPageStickyHeaderView()
    let scrolledStickyHeaderView = UserPageStickyHeaderView()
    
    let userPageOverviewView = UserPageOverviewView()
    let userPageFeedView = UserPageFeedView()
    
    //In VC
    let backButton = UIButton()
    
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
        
        scrollView.do {
            $0.backgroundColor = .wssWhite
            $0.contentInsetAdjustmentBehavior = .never
            $0.showsVerticalScrollIndicator = false
        }
        
        scrolledStickyHeaderView.do {
            $0.isHidden = true
        }
        
        userPageFeedView.isHidden = true
        
        backButton.do {
            $0.setImage(.icNavigateLeft.withRenderingMode(.alwaysOriginal).withTintColor(.wssGray300), for: .normal)
        }
    }
    
    private func setHierarchy() {
        addSubviews(scrollView,
                    scrolledStickyHeaderView)
        
        scrollView.addSubview(contentView)
        contentView.addSubviews(headerView,
                                mainStickyHeaderView,
                                userPageOverviewView,
                                userPageFeedView)
    }
    
    private func setLayout() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.left.right.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        headerView.snp.makeConstraints {
            $0.top.width.equalToSuperview()
        }
        
        mainStickyHeaderView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.width.equalToSuperview()
            $0.height.equalTo(47)
        }
        
        scrolledStickyHeaderView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.width.equalToSuperview()
            $0.height.equalTo(47)
        }
        
        [userPageOverviewView, userPageFeedView].forEach { view in
            view.snp.makeConstraints {
                $0.top.equalTo(headerView.snp.bottom).offset(47)
                $0.width.equalToSuperview()
            }
        }
    }
    
    //MARK: - Data
    
    func showContentView(showLibraryView: Bool) {
        userPageOverviewView.isHidden = !showLibraryView
        userPageFeedView.isHidden = showLibraryView
    }
}
