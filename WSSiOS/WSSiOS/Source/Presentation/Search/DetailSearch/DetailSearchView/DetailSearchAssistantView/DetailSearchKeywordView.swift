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
       
    }
    
    private func setHierarchy() {
        self.addSubview(searchBarView)
    }
    
    private func setLayout() {
        searchBarView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
    }
}
