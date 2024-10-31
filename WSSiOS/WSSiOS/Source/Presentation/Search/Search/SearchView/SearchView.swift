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
    let induceLoginModalView = HomeInduceLoginModalView()
    
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
        
        induceLoginModalView.do {
            $0.isHidden = true
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(scrollView,
                         titleLabel,
                         searchbarView,
                         induceLoginModalView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(searchDetailInduceView,
                                sosopickView)
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(12)
            $0.leading.equalToSuperview().inset(20)
        }
        
        searchbarView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(42)
        }
        
        induceLoginModalView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(searchbarView.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.top.equalTo(scrollView.contentLayoutGuide).inset(10)
            $0.leading.trailing.bottom.equalTo(scrollView.contentLayoutGuide)
            $0.height.greaterThanOrEqualTo(self.snp.height).priority(.low)
            $0.width.equalTo(scrollView.snp.width)
        }
        
        searchDetailInduceView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(256)
        }
        
        sosopickView.snp.makeConstraints {
            $0.top.equalTo(searchDetailInduceView.snp.bottom).offset(24)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

