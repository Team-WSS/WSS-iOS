//
//  NormalSearchView.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/27/24.
//

import UIKit

import SnapKit
import Then

final class NormalSearchView: UIView {
    
    //MARK: - Components
    
    let headerView = NormalSearchHeaderView()
    let resultView = NormalSearchResultView()
    let emptyView = NormalSearchEmptyView()
    let induceLoginModalView = HomeInduceLoginModalView()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setHierarchy()
        setLayout()
        
        resultView.isHidden = true
        emptyView.isHidden = true
        induceLoginModalView.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI

    private func setHierarchy() {
        self.addSubviews(headerView,
                         resultView,
                         emptyView,
                         induceLoginModalView)
    }
    
    private func setLayout() {
        headerView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(1)
            $0.leading.trailing.equalToSuperview()
        }
        
        resultView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        emptyView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        induceLoginModalView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
