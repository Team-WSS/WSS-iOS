//
//  MemoCreateView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 1/13/24.
//

import UIKit

import SnapKit
import Then

final class MemoCreateView: UIView {
    
    // MARK: - UI Components
    
    let memoHeaderView = MemoHeaderView()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierachy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - set UI
    
    private func setUI() {
    }
    
    // MARK: - set Hierachy
    
    private func setHierachy() {
        self.addSubviews(memoHeaderView)
    }
    
    // MARK: - set Layout
    
    private func setLayout() {
        memoHeaderView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
    }
}
