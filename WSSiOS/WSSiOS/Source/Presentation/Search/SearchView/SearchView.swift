//
//  SearchView.swift
//  WSSiOS
//
//  Created by 최서연 on 1/9/24.
//

import UIKit

final class SearchView: UIView {
    
    //MARK: - Components
    
    let headerView = SearchHeaderView()
    private let dividerLine = UIView()
    let mainResultView = SearchResultView()
    
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
        self.backgroundColor = .White
        
        dividerLine.do {
            $0.backgroundColor = .Gray50
        }
    }

    private func setHierarchy() {
        self.addSubviews(headerView,
                         dividerLine,
                         mainResultView)
    }

    private func setLayout() {
        headerView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
        }
        
        dividerLine.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        mainResultView.snp.makeConstraints {
            $0.top.equalTo(dividerLine.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
