//
//  DetailSearchView.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 7/18/24.
//

import UIKit

import SnapKit
import Then

final class DetailSearchView: UIView {
    
    //MARK: - UI Components
    
    let detailSearchHeaderView = DetailSearchHeaderView()
    let detailSearchInfoView = DetailSearchInfoView()
    let detailSearchKeywordView = DetailSearchKeywordView()
    
    let bottomView = WSSBottomActionView()
 
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        self.do {
            $0.backgroundColor = .wssWhite
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(detailSearchHeaderView,
                         detailSearchInfoView,
                         detailSearchKeywordView,
                         bottomView)
    }
    
    private func setLayout() {
        detailSearchHeaderView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.leading.equalToSuperview().inset(6)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        detailSearchKeywordView.snp.makeConstraints {
            $0.top.equalTo(detailSearchHeaderView.snp.bottom).offset(UIScreen.isSE ? 15 : 30)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(bottomView.snp.top).offset(-10)
        }

        detailSearchInfoView.snp.makeConstraints {
            $0.top.equalTo(detailSearchHeaderView.snp.bottom).offset(UIScreen.isSE ? 15 : 30)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(bottomView.snp.top).offset(-10)
        }

        bottomView.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
        }
    }
    
    //MARK: - Custom Method
    
    func updateTab(selected tab: DetailSearchTab) {
        detailSearchHeaderView.updateTab(selected: tab)
        updateSelectedTabView(selected: tab)
    }
    
    private func updateSelectedTabView(selected tab: DetailSearchTab) {
        switch tab {
        case .info:
            detailSearchInfoView.isHidden = false
            detailSearchKeywordView.isHidden = true
        case .keyword:
            detailSearchInfoView.isHidden = true
            detailSearchKeywordView.isHidden = false
        }
    }
}
