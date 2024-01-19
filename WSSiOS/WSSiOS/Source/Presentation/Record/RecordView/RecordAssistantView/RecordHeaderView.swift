//
//  RecordHeaderView.swift
//  WSSiOS
//
//  Created by 최서연 on 1/12/24.
//

import UIKit

import SnapKit
import Then

final class RecordHeaderView: UIView {
    
    //MARK: - UI Components
    
    let recordCountLabel = UILabel()
    let headerAlignmentButton = RecordHeaderAlignmentButton()
    
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
    
    //MARK: - set UI
    
    private func setUI() {
        self.do {
            $0.backgroundColor = .Gray50
        }
        
        recordCountLabel.do {
            $0.font = .Label1
            $0.textColor = .Gray200
        }
    }
    
    //MARK: - set Hierachy
    
    private func setHierachy() {
        self.addSubviews(recordCountLabel,
                         headerAlignmentButton)
    }
    
    //MARK: - set Layout
    
    private func setLayout() {
        recordCountLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
        
        headerAlignmentButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
        }
    }
}
