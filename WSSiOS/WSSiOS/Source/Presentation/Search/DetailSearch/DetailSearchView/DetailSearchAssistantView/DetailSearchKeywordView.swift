//
//  DetailSearchKeywordView.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 7/21/24.
//

import UIKit

import SnapKit
import Then

final class DetailSearchKeywordView: UIView {
    
    //MARK: - UI Components
    
    let searchBarView = DetailSearchKeywordSearchBarView()
    let categoryBackgroundView = UIView()
    let categoryView = DetailSearchKeywordCategoryView()
    
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
        categoryBackgroundView.do {
            $0.backgroundColor = .wssGray50
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(searchBarView,
                         categoryBackgroundView)
        categoryBackgroundView.addSubview(categoryView)
    }
    
    private func setLayout() {
        searchBarView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        categoryBackgroundView.snp.makeConstraints {
            $0.top.equalTo(searchBarView.snp.bottom).offset(25)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(500)
        }
        
        categoryView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.horizontalEdges.equalToSuperview().inset(12)
        }
    }
}
