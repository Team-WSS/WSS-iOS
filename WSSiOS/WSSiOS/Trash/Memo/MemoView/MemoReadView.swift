//
//  MemoReadView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 1/13/24.
//

import UIKit

import SnapKit
import Then

final class MemoReadView: UIView {
    
    //MARK: - Components
    
    let memoHeaderView = MemoHeaderView()
    let memoReadContentView = MemoReadContentView()
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI
    
    private func setHierarchy() {
        self.addSubviews(memoHeaderView,
                         memoReadContentView)
    }
    
    private func setLayout() {
        memoHeaderView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        memoReadContentView.snp.makeConstraints {
            $0.top.equalTo(memoHeaderView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
