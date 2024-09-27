//
//  NovelKeywordSelectModalView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 9/17/24.
//

import UIKit

import SnapKit
import Then

final class NovelKeywordSelectModalView: UIView {
    
    //MARK: - Components
    
    private let contentView = UIView()
    let closeButton = UIButton()
    private let titleLabel = UILabel()
    let novelKeywordSelectSearchBarView = NovelKeywordSelectSearchBarView()
    let novelSelectedKeywordListView = NovelSelectedKeywordListView()
    private let dividerView = UIView()
    let novelKeywordSelectEmptyView = NovelKeywordSelectEmptyView()
    let novelKeywordSelectSearchResultView = NovelKeywordSelectSearchResultView()
    let novelKeywordSelectModalButtonView = NovelKeywordSelectModalButtonView()
    
    //MARK: - Life Cycle
    
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
        contentView.do {
            $0.backgroundColor = .wssWhite
            $0.layer.cornerRadius = 16
            $0.layer.maskedCorners = [.layerMinXMinYCorner,
                                      .layerMaxXMinYCorner]
        }
        
        closeButton.do {
            $0.setImage(.icCancelModal, for: .normal)
        }
        
        titleLabel.do {
            $0.applyWSSFont(.title1, with: StringLiterals.NovelReview.KeywordSearch.keywordSelect)
            $0.textColor = .wssBlack
        }
        
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
        self.addSubview(contentView)
        contentView.addSubviews(closeButton,
                                titleLabel,
                                novelKeywordSelectSearchBarView,
                                novelSelectedKeywordListView,
                                dividerView,
                                novelKeywordSelectEmptyView,
                                novelKeywordSelectSearchResultView,
                                novelKeywordSelectModalButtonView)
    }
    
    private func setLayout() {
        contentView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(UIScreen.main.bounds.height - 81)
        }
        
        closeButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview()
            $0.size.equalTo(65)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(25)
        }
        
        novelKeywordSelectSearchBarView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
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
            $0.bottom.equalTo(novelKeywordSelectModalButtonView.snp.top)
        }
        
        novelKeywordSelectModalButtonView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    //MARK: - Custom Method
    
    func showSearchResultView(show: Bool) {
        novelKeywordSelectSearchResultView.isHidden = !show
    }
    
    func showEmptyView(show: Bool) {
        novelKeywordSelectEmptyView.isHidden = !show
    }
    
    func updateNovelKeywordSelectModalViewLayout(isSelectedKeyword: Bool) {
        novelSelectedKeywordListView.do {
            $0.isHidden = !isSelectedKeyword
        }
        
        novelKeywordSelectSearchResultView.snp.updateConstraints {
            $0.top.equalTo(novelKeywordSelectSearchBarView.snp.bottom).offset(isSelectedKeyword ? 53 : 0)
        }
    }
}
