//
//  SearchView.swift
//  WSSiOS
//
//  Created by 최서연 on 1/9/24.
//

import UIKit

import SnapKit
import Then

final class SearchView: UIView {
    
    //MARK: - Components
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let titleLabel = UILabel()
    let searchbarView = SearchBarView()
    let searchDetailInduceView = SearchDetailInduceView()
    let sosopickView = SearchSosoPickView()
    private let emptyView = UIView()
    
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
    
    //MARK: - set UI
    
    private func setUI() {
        scrollView.do {
            $0.showsVerticalScrollIndicator = false
        }
        
        titleLabel.do {
            $0.fontHeadline1Attribute(with: StringLiterals.Search.title)
            $0.textColor = .wssBlack
        }
        
        emptyView.do {
            $0.backgroundColor = .white
        }
    }
    
    private func setHierarchy() {
        /// SE 기기대응을 위한 조건 적용
        if UIScreen.main.bounds.height < 812 {
            self.addSubviews(scrollView,
                             titleLabel)
            scrollView.addSubview(contentView)
            contentView.addSubviews(searchbarView,
                                    searchDetailInduceView,
                                    sosopickView,
                                    emptyView)
        } else {
            self.addSubviews(titleLabel,
                             searchbarView,
                             searchDetailInduceView,
                             sosopickView,
                             emptyView)
        }
    }
    
    private func setLayout() {
        if UIScreen.main.bounds.height < 812 {
            titleLabel.snp.makeConstraints {
                $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(12)
                $0.leading.equalToSuperview().inset(20)
            }
            
            scrollView.snp.makeConstraints {
                $0.top.equalTo(titleLabel.snp.bottom).offset(10)
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
            }
            
            contentView.snp.makeConstraints {
                $0.top.equalTo(scrollView.contentLayoutGuide).inset(10)
                $0.leading.trailing.bottom.equalTo(scrollView.contentLayoutGuide)
                $0.height.greaterThanOrEqualTo(self.snp.height).priority(.low)
                $0.width.equalTo(scrollView.snp.width)
            }
            
            searchbarView.snp.makeConstraints {
                $0.top.equalToSuperview()
                $0.leading.trailing.equalToSuperview().inset(20)
                $0.height.equalTo(42)
            }
            
            searchDetailInduceView.snp.makeConstraints {
                $0.top.equalTo(searchbarView.snp.bottom).offset(14)
                $0.leading.trailing.equalToSuperview().inset(20)
            }
            
            sosopickView.snp.makeConstraints {
                $0.top.equalTo(searchDetailInduceView.snp.bottom).offset(24)
                $0.leading.trailing.bottom.equalToSuperview()
            }
        }
        else {
            titleLabel.snp.makeConstraints {
                $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(12)
                $0.leading.equalToSuperview().inset(20)
            }
            
            searchbarView.snp.makeConstraints {
                $0.top.equalTo(titleLabel.snp.bottom).offset(20)
                $0.leading.trailing.equalToSuperview().inset(20)
                $0.height.equalTo(42)
            }
            
            searchDetailInduceView.snp.makeConstraints {
                $0.top.equalTo(searchbarView.snp.bottom).offset(14)
                $0.leading.trailing.equalToSuperview().inset(20)
            }
            
            sosopickView.snp.makeConstraints {
                $0.top.equalTo(searchDetailInduceView.snp.bottom).offset(24)
                $0.leading.trailing.equalToSuperview()
            }
            
            emptyView.snp.makeConstraints {
                $0.top.equalTo(sosopickView.snp.bottom)
                $0.leading.trailing.bottom.equalToSuperview()
            }
        }
    }
}
