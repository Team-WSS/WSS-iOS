//
//  SearchBarView.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/26/24.
//

import UIKit

import SnapKit
import Then

final class SearchBarView: UIView {
    
    //MARK: - Components
    
    private var searchBarLabel = UILabel()
    private var searchIconImageView = UIImageView()
    
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
    
    //MARK: - UI
    
    private func setUI() {
        self.do {
            $0.backgroundColor = .wssGray50
            $0.layer.cornerRadius = 14
        }
        
        searchBarLabel.do {
            $0.fontLabel1Attribute(with: StringLiterals.Search.searchbar)
            $0.textColor = .wssGray200
        }
        
        searchIconImageView.do {
            $0.image = .icSearch
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(searchBarLabel,
                         searchIconImageView)
    }
    
    private func setLayout() {
        searchBarLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
        }
        
        searchIconImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(15)
        }
    }
}
