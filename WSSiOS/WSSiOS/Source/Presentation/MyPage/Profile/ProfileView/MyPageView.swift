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
    let scrolledStickyHeaderView = MyPageStickyHeaderView()
    
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
        self.backgroundColor = .wssPrimary20
        
        scrollView.do {
            $0.contentInsetAdjustmentBehavior = .never
            $0.showsVerticalScrollIndicator = false
        }
        
        scrolledStickyHeaderView.do {
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
                    scrolledStickyHeaderView)
        
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
        
        [myPageLibraryView, myPageFeedView].forEach { view in
            view.snp.makeConstraints {
                $0.top.equalTo(headerView.snp.bottom).offset(47)
                $0.width.equalToSuperview()
            }
        }
    }
    
    //MARK: - Data
    
    func isUnknownUserProfile() {
        headerView.bindData(data: MyProfileResult(nickname: StringLiterals.MyPage.Profile.unknownUserNickname,
                                                  intro: "",
                                                  avatarImage: "",
                                                  genrePreferences: []))
        mainStickyHeaderView.isHidden = true
        myPageLibraryView.isHidden = true
        myPageFeedView.isHidden = true
    }
    
    func showContentView(showLibraryView: Bool) {
        myPageLibraryView.isHidden = !showLibraryView
        myPageFeedView.isHidden = showLibraryView
    }
}
