//
//  UserPageFeedDetailView.swift
//  WSSiOS
//
//  Created by 신지원 on 12/3/24.
//

import UIKit

import SnapKit
import Then

final class UserPageFeedDetailView: UIView {
    
    //MARK: - Components
    
    let userPageFeedDetailTableView = UITableView(frame: .zero, style: .plain)
    
    //In VC
    let backButton = UIButton()

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
        userPageFeedDetailTableView.do {
            $0.separatorStyle = .none
        }
        
        backButton.do {
            $0.setImage(.icNavigateLeft.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    
    private func setHierarchy() {
        self.addSubview(userPageFeedDetailTableView)
    }
    
    private func setLayout() {
        userPageFeedDetailTableView.snp.makeConstraints() {
            $0.edges.equalToSuperview()
        }
    }
}
