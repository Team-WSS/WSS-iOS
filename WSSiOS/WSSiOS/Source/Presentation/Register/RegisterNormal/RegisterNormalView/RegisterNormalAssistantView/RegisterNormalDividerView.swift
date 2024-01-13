//
//  RegisterNormalDividerView.swift
//  WSSiOS
//
//  Created by 이윤학 on 1/11/24.
//


import UIKit

import SnapKit
import Then

final class RegisterNormalDividerView: UIView {
    
    // MARK: - UI Components
    
    private let dividerView = UIView()
    private let topBorderView = UIView()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHieararchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Method
    
    private func setUI() {
        dividerView.do {
            $0.backgroundColor = .Gray50
        }
        topBorderView.do {
            $0.backgroundColor = .Gray70
        }
    }
    
    private func setHieararchy() {
        self.addSubviews(dividerView, 
                         topBorderView)
    }
    
    private func setLayout() {
        dividerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(7)
        }
        
        topBorderView.snp.makeConstraints {
            $0.bottom.equalTo(dividerView.snp.top)
            $0.height.equalTo(0.7)
            $0.horizontalEdges.equalToSuperview()
        }
    }
}
