//
//  HomeView.swift
//  WSSiOS
//
//  Created by 최서연 on 1/9/24.
//

import UIKit

final class HomeView: UIView {
    
    //MARK: - UI Components
    
    private let headerView = HomeHeaderView()
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setHierachy()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setHierachy() {
        self.addSubviews(headerView)
    }
    
    private func setLayout() {
        headerView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            $0.leading.equalToSuperview().inset(20)
            $0.centerX.equalToSuperview()
        }
    }
}
