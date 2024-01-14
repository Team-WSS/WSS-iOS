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
    
    public let memoHeaderView = MemoHeaderView()
    public let memoCreateContentView = MemoCreateContentView()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setHierachy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - set Hierachy
    
    private func setHierachy() {
        self.addSubviews(memoHeaderView,
                         memoCreateContentView)
    }
    
    // MARK: - set Layout
    
    private func setLayout() {
        memoHeaderView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        memoCreateContentView.snp.makeConstraints {
            $0.top.equalTo(memoHeaderView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
