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
    let contentView = UIView()
    
    let headerView = MyPageProfileHeaderView()
    let mainStickyHeaderView = MyPageStickyHeaderView()
    let scrolledStstickyHeaderView = MyPageStickyHeaderView()
    
    let myPageLibraryView = MyPageLibraryView()
    let myPageFeedView = UIView()
    
    //In VC
    let settingButton = UIButton()
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
        self.backgroundColor = .wssWhite
        
        scrolledStstickyHeaderView.do {
            $0.isHidden = true
        }
        
        myPageFeedView.isHidden = true
        
        settingButton.do {
            $0.setImage(UIImage(resource: .icSetting), for: .normal)
        }
        
        backButton.do {
            $0.setImage(.icNavigateLeft.withRenderingMode(.alwaysOriginal).withTintColor(.wssGray300), for: .normal)
        }
    }
    
    private func setHierarchy() {
        addSubviews(scrollView,
                    scrolledStstickyHeaderView)
        
        scrollView.addSubview(contentView)
        contentView.addSubviews(headerView,
                                mainStickyHeaderView,
                                myPageLibraryView,
                                myPageFeedView)
    }
    
    private func setLayout() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.left.right.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
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
            $0.leading.trailing.equalToSuperview()
        }
        
        myPageFeedView.snp.makeConstraints {
            $0.top.equalTo(mainStickyHeaderView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.bottom.equalTo(myPageLibraryView.snp.bottom)
        }
    }
    
    func dataBind(isPrivate: Bool) {
        if isPrivate {
            
        }
    }
}
