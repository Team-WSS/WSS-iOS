//
//  SearchView.swift
//  WSSiOS
//
//  Created by 최서연 on 1/9/24.
//

import UIKit

final class SearchView: UIView {
    
    //MARK: - Components
    
    private let titleLabel = UILabel()
    private let searchbarView = SearchBarView()
    
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
        titleLabel.do {
            $0.fontHeadline1Attribute(with: StringLiterals.Search.title)
            $0.textColor = .wssBlack
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(titleLabel,
                         searchbarView)
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
    }
}
