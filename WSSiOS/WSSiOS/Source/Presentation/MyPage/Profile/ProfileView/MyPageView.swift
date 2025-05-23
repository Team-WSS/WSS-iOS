//
//  MyPageView.swift
//  WSSiOS
//
//  Created by 신지원 on 5/21/25.
//

import UIKit

import SnapKit
import Then

final class MyPageView: UIView {
    
    //MARK: - Components
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    let headerView = MyPageProfileHeaderView()
    let myPageLibraryView = UserPageLibraryView()
    
    //In VC
    let settingButton = UIButton()
    
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
        
        settingButton.do {
            $0.setImage(UIImage(resource: .icSetting), for: .normal)
        }
    }
    
    private func setHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(headerView,
                                myPageLibraryView)
    }
    
    private func setLayout() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.width.equalToSuperview()
        }
        
        headerView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(20)
        }
        
        myPageLibraryView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.width.bottom.equalToSuperview()
        }
    }
}
