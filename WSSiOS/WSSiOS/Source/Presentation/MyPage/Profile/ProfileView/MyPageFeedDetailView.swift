//
//  MyPageFeedDetailView.swift
//  WSSiOS
//
//  Created by 신지원 on 12/3/24.
//

import UIKit

import SnapKit
import Then

final class MyPageFeedDetailView: UIView {
    
    //MARK: - Components
    
    let myPageFeedDetailTableView = UITableView(frame: .zero, style: .plain)
    
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
        
        myPageFeedDetailTableView.do {
            $0.separatorStyle = .none
            $0.showsVerticalScrollIndicator = false
        }
        
        backButton.do {
            $0.setImage(.icNavigateLeft.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    
    private func setHierarchy() {
        self.addSubview(myPageFeedDetailTableView)
    }
    
    private func setLayout() {
        myPageFeedDetailTableView.snp.makeConstraints() {
            $0.edges.equalToSuperview()
        }

        backButton.snp.makeConstraints {
            $0.size.equalTo(44)
        }
    }
}

