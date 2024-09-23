//
//  MemoEditView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 1/13/24.
//

import UIKit

import SnapKit
import Then

final class MemoEditView: UIView {
    
    //MARK: - Components
    
    let memoHeaderView = MemoHeaderView()
    let memoEditContentView = MemoEditContentView()
    
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
                         memoEditContentView)
    }
    
    private func setLayout() {
        memoHeaderView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        memoEditContentView.snp.makeConstraints {
            $0.top.equalTo(memoHeaderView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
