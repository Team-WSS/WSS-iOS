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
    
    let novelKeywordSelectSearchBarView = NovelKeywordSelectSearchBarView()
    let novelSelectedKeywordListView = NovelSelectedKeywordListView()
    private let dividerView = UIView()
    let novelKeywordSelectEmptyView = NovelKeywordSelectEmptyView()
    let novelKeywordSelectSearchResultView = NovelKeywordSelectSearchResultView()
    let novelKeywordSelectCategoryListView = NovelKeywordSelectCategoryListView()
    
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
        dividerView.do {
            $0.backgroundColor = .wssGray50
        }
        
        novelKeywordSelectEmptyView.do {
            $0.isHidden = true
        }
        
        novelKeywordSelectSearchResultView.do {
            $0.isHidden = true
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(novelKeywordSelectSearchBarView,
                         novelSelectedKeywordListView,
                         dividerView,
                         novelKeywordSelectEmptyView,
                         novelKeywordSelectSearchResultView,
                         novelKeywordSelectCategoryListView)
    }
    
    private func setLayout() {
        novelKeywordSelectSearchBarView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        novelSelectedKeywordListView.snp.makeConstraints {
            $0.top.equalTo(novelKeywordSelectSearchBarView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        dividerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(novelKeywordSelectSearchResultView.snp.top)
            $0.height.equalTo(1)
        }
        
        novelKeywordSelectEmptyView.snp.makeConstraints {
            $0.leading.trailing.centerY.equalToSuperview()
        }
        
        novelKeywordSelectSearchResultView.snp.makeConstraints {
            $0.top.equalTo(novelKeywordSelectSearchBarView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        novelKeywordSelectCategoryListView.snp.makeConstraints {
            $0.top.equalTo(novelKeywordSelectSearchBarView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    //MARK: - Custom Method
    
    func showEmptyView(show: Bool) {
        novelKeywordSelectEmptyView.isHidden = !show
    }
    
    func showSearchResultView(show: Bool) {
        novelKeywordSelectSearchResultView.isHidden = !show
    }
    
    func showCategoryListView(show: Bool) {
        novelKeywordSelectCategoryListView.isHidden = !show
    }
    
    func updateNovelKeywordSelectModalViewLayout(isSelectedKeyword: Bool) {
        novelSelectedKeywordListView.do {
            $0.isHidden = !isSelectedKeyword
        }
        
        novelKeywordSelectSearchResultView.snp.updateConstraints {
            $0.top.equalTo(novelKeywordSelectSearchBarView.snp.bottom).offset(isSelectedKeyword ? 53 : 0)
        }
        
        novelKeywordSelectCategoryListView.snp.updateConstraints {
            $0.top.equalTo(novelKeywordSelectSearchBarView.snp.bottom).offset(isSelectedKeyword ? 53 : 0)
        }
    }
}
