//
//  FeedGenreView.swift
//  WSSiOS
//
//  Created by 신지원 on 5/14/24.
//

import UIKit

import SnapKit
import Then

final class FeedGenreView: UIView {
    
    //MARK: - Components
    
    let feedTableView = UITableView(frame: .zero, style: .plain)
    
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
    
    //MARK: - UI
    
    private func setUI() {
        self.backgroundColor = .wssWhite
        
        feedTableView.do {
            $0.showsVerticalScrollIndicator = false
            $0.separatorStyle = .none
        }
    }
    
    private func setHierarchy() {
        addSubview(feedTableView)
    }
    
    private func setLayout() {
        feedTableView.snp.makeConstraints() {
            $0.edges.equalToSuperview()
        }
    }
}
