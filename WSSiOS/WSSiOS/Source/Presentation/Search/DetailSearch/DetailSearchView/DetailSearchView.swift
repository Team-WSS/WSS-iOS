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
    
    private let backgroundView = UIView()
    let cancelModalButton = UIButton()
    
    let detailSearchHeaderView = DetailSearchHeaderView()
    let detailSearchInfoView = DetailSearchInfoView()
    let detailSearchKeywordView = DetailSearchKeywordView()
    let detailSearchBottomView = DetailSearchBottomView()
    
    // Home Indicator 배경
    private let backgroundBottomView = UIView()
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundView.roundCorners([.topLeft, .topRight], radius: 15)
    }
    
    private func setUI() {
        self.backgroundColor = .black.withAlphaComponent(0.6)
        
        backgroundView.do {
            $0.backgroundColor = .wssWhite
        }
        
        cancelModalButton.do {
            $0.setImage(.icCancelModal.withRenderingMode(.alwaysOriginal).withTintColor(.wssGray300), for: .normal)
        }
        
        backgroundBottomView.do {
            $0.backgroundColor = .wssWhite
        }
    }
    
    private func setHierarchy() {
        backgroundView.addSubviews(cancelModalButton,
                                   detailSearchHeaderView,
                                   detailSearchInfoView,
                                   detailSearchKeywordView,
                                   detailSearchBottomView)
        self.addSubviews(backgroundView,
                         backgroundBottomView)
    }
    
    private func setLayout() {
        backgroundView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(82)
            $0.leading.trailing.bottom.equalToSuperview()
            
            cancelModalButton.snp.makeConstraints {
                $0.size.equalTo(25)
                $0.top.trailing.equalToSuperview().inset(20)
            }
            
            detailSearchHeaderView.snp.makeConstraints {
                $0.top.leading.equalToSuperview().inset(34)
            }
            
            detailSearchKeywordView.snp.makeConstraints {
                $0.top.equalTo(detailSearchHeaderView.snp.bottom).offset(UIScreen.isSE ? 15 : 30)
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalTo(detailSearchBottomView.snp.top)
            }
            
            detailSearchInfoView.snp.makeConstraints {
                $0.top.equalTo(detailSearchHeaderView.snp.bottom).offset(UIScreen.isSE ? 15 : 33)
                $0.leading.trailing.equalToSuperview()
            }
            
            detailSearchBottomView.snp.makeConstraints {
                $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
                $0.leading.trailing.equalToSuperview()
            }
        }
        
        backgroundBottomView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.bottomMargin)
            $0.horizontalEdges.bottom.equalToSuperview()
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
