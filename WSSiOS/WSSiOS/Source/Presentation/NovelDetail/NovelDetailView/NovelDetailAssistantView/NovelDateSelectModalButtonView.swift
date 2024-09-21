//
//  NovelDateSelectModalButtonView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 9/21/24.
//

import UIKit

import SnapKit
import Then

final class NovelDateSelectModalButtonView: UIView {
    
    //MARK: - Components
    
    let completeButton = UIButton()
    private let completeLabel = UILabel()
    let removeButton = UIButton()
    private let removeLabel = UILabel()
    
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
    
    //MARK: - UI
    
    private func setUI() {
        completeButton.do {
            $0.backgroundColor = .wssPrimary100
            $0.layer.cornerRadius = 12
        }
        
        completeLabel.do {
            $0.applyWSSFont(.title1, with: StringLiterals.NovelReview.Date.complete)
            $0.textColor = .wssWhite
            $0.isUserInteractionEnabled = false
        }
        
        removeLabel.do {
            $0.applyWSSFont(.body1, with: StringLiterals.NovelReview.Date.removeDate)
            $0.textColor = .wssPrimary100
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(completeButton,
                         removeButton)
        completeButton.addSubview(completeLabel)
        removeButton.addSubview(removeLabel)
    }
    
    private func setLayout() {
        completeButton.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(53)
            
            completeLabel.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
        }
        
        removeButton.snp.makeConstraints {
            $0.centerX.bottom.equalToSuperview()
            $0.top.equalTo(completeButton.snp.bottom).offset(5)
            $0.width.equalTo(101)
            $0.height.equalTo(53)
            
            removeLabel.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
        }
    }
}
