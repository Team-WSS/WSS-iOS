//
//  SearchResultView.swift
//  WSSiOS
//
//  Created by 최서연 on 1/6/24.
//

import UIKit

import SnapKit
import Then

final class SearchResultView: UIView {
    
    //MARK: set Properties
    
    private let searchTableView = UITableView()
    
    //MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierachy()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: set UI
    
    private func setUI() {
        searchTableView.do {
            $0.rowHeight = 104
        }
    }
    
    //MARK: set Hierachy
    
    private func setHierachy() {
        self.addSubview(searchTableView)
    }
    
    //MARK: set Layout
    
    private func setLayout() {
        searchTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
