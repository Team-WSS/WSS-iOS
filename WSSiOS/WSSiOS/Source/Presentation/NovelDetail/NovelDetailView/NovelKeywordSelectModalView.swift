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
    
    let contentView = UIView()
    let closeButton = UIButton()
    private let titleLabel = UILabel()
    let novelKeywordSelectSearchBarView = NovelKeywordSelectSearchBarView()
    let novelKeywordSelectSearchResultView = NovelKeywordSelectSearchResultView()
    let novelKeywordSelectModalButtonView = NovelKeywordSelectModalButtonView()
    let novelSelectedKeywordListView = NovelSelectedKeywordListView()
    
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
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 16
            $0.layer.maskedCorners = [.layerMinXMinYCorner,
                                      .layerMaxXMinYCorner]
        }
        
        closeButton.do {
            $0.setImage(.icCacelModal, for: .normal)
        }
        
        titleLabel.do {
            $0.applyWSSFont(.title1, with: StringLiterals.NovelReview.KeywordSearch.keywordSelect)
            $0.textColor = .wssBlack
        }
    }
    
    private func setHierarchy() {
        self.addSubview(contentView)
        contentView.addSubviews(closeButton,
                                titleLabel,
                                novelKeywordSelectSearchBarView,
                                novelKeywordSelectSearchResultView,
                                novelKeywordSelectModalButtonView,
                                novelSelectedKeywordListView)
    }
    
    private func setLayout() {
        contentView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(UIScreen.main.bounds.height - 81)
        }
        
        closeButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(20)
            $0.size.equalTo(25)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(25)
        }
        
        novelKeywordSelectSearchBarView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview()
        }
        
        novelKeywordSelectSearchResultView.snp.makeConstraints {
            $0.top.equalTo(novelKeywordSelectSearchBarView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview()
        }
        
        novelKeywordSelectModalButtonView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.safeAreaLayoutGuide)
        }
        
        novelSelectedKeywordListView.snp.makeConstraints {
            $0.top.equalTo(novelKeywordSelectSearchBarView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    //MARK: - Custom Method
    
    func showSearchResultView(show: Bool) {
        novelKeywordSelectSearchResultView.do {
            $0.isHidden = !show
        }
    }
}