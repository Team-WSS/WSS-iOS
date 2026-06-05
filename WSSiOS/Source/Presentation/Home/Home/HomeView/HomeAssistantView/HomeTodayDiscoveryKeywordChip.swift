//
//  HomeTodayDiscoveryKeywordChip.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 6/5/26.
//

import UIKit

import SnapKit
import Then

final class HomeTodayDiscoveryKeywordChip: UIView {
    
    //MARK: - Properties
    
    private let chipHeight: CGFloat = 22
    
    //MARK: - Components
    
    private let label = UILabel()
    
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
    
    private func setUI() {
        self.do {
            $0.layer.cornerRadius = chipHeight / 2
            $0.backgroundColor = .wssPrimary20
        }
    }
    
    private func setHierarchy() {
        self.addSubview(label)
    }
    
    private func setLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(chipHeight)
        }
        
        label.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
        }
    }
    
    //MARK: - Custom Method
    
    func setText(_ text: String) {
        label.do {
            $0.applyWSSFont(.label2,with: text)
            $0.textColor = .wssPrimary100
        }
    }
}
