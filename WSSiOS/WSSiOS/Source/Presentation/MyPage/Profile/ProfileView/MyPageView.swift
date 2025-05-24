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
    let myPageProfileView = MyPageProfileView()
    let myPageLibraryStatusView = UserLibraryStatusView()
    let myPagePreferencesView = MyPagePreferencesView()
    
    private let dividerView = UIView()
    
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
        self.backgroundColor = .wssWhite
        
        scrollView.do {
            $0.backgroundColor = .wssWhite
            $0.contentInsetAdjustmentBehavior = .never
            $0.showsVerticalScrollIndicator = false
        }
        
        settingButton.do {
            $0.setImage(UIImage(resource: .icSetting), for: .normal)
        }
        
        dividerView.do {
            $0.backgroundColor = .wssGray50
        }
    }
    
    private func setHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(myPageProfileView,
                                myPageLibraryStatusView,
                                dividerView,
                                myPagePreferencesView)
    }
    
    private func setLayout() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.width.equalToSuperview()
        }
        
        myPageProfileView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(20)
        }
        
        myPageLibraryStatusView.snp.makeConstraints {
            $0.top.equalTo(myPageProfileView.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        dividerView.snp.makeConstraints {
            $0.top.equalTo(myPageLibraryStatusView.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(3)
        }
        
        myPagePreferencesView.snp.makeConstraints {
            $0.top.equalTo(dividerView.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(40)
        }
    }
}
