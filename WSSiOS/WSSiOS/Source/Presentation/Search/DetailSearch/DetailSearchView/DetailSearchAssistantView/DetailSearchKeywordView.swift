//
//  DetailSearchKeywordView.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 7/21/24.
//

import UIKit

import SnapKit
import Then

final class DetailSearchKeywordView: UIView {
    
    //MARK: - UI Components
    
    // 뷰 구현을 위한 임시 컴포넌트
    private let label = UILabel()
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        label.do {
            $0.applyWSSFont(.body1, with: "상세탐색뷰의 키워드뷰입니다.")
        }
    }
    
    private func setHierarchy() {
        self.addSubview(label)
    }
    
    private func setLayout() {
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
