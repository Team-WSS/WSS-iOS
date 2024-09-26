//
//  NovelDetailFeedListView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 9/27/24.
//

import UIKit

import SnapKit
import Then

final class NovelDetailFeedListView: UIView {
    
    //MARK: - Components
    
    let feedTableView = UITableView(frame: .zero, style: .plain)
    
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
        feedTableView.do {
            $0.showsVerticalScrollIndicator = false
            $0.separatorStyle = .none
            $0.isScrollEnabled = false
        }
    }
    
    private func setHierarchy() {
        self.addSubview(feedTableView)
    }
    
    private func setLayout() {
        feedTableView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(28)
            $0.height.equalTo(0)
        }
    }
    
    //MARK: - Custom Method
    
    func updateTableViewHeight(height: CGFloat) {
        feedTableView.snp.updateConstraints {
            $0.height.equalTo(height)
        }
    }
}
