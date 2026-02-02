//
//  NovelDetailHeaderDropdownView.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 10/14/24.
//

import UIKit

import SnapKit
import Then

final class NovelDetailHeaderDropdownView: UIView {
    
    //MARK: - UI Components

    let topDropdownButton = UIButton()
    private let topDropdownLabel = UILabel()
    
    private let dividerLine = UIView()
    
    let bottomDropdownButton = UIButton()
    private let bottomDropdownLabel = UILabel()
    
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
        self.do {
            $0.layer.cornerRadius = 14
            $0.layer.masksToBounds = true
            $0.backgroundColor = .wssWhite
            
            $0.layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
            $0.layer.shadowOpacity = 1
            $0.layer.shadowOffset = CGSize(width: 0, height: 2)
            $0.layer.shadowRadius = 15
            $0.layer.masksToBounds = false
        }
        
        topDropdownLabel.do {
            $0.applyWSSFont(.body2, with: StringLiterals.NovelDetail.Header.errorReport)
            $0.textColor = .wssBlack
            $0.isUserInteractionEnabled = false
        }
        
        dividerLine.do {
            $0.backgroundColor = .wssGray50
        }
        
        bottomDropdownLabel.do {
            $0.applyWSSFont(.body2, with: StringLiterals.NovelDetail.Header.deleteReview)
            $0.textColor = .wssBlack
            $0.isUserInteractionEnabled = false
        }
    }
    
    private func setHierarchy() {
        topDropdownButton.addSubview(topDropdownLabel)
        bottomDropdownButton.addSubview(bottomDropdownLabel)
        
        self.addSubviews(topDropdownButton,
                         dividerLine,
                         bottomDropdownButton)
    }
    
    private func setLayout() {
        self.snp.makeConstraints {
            $0.width.equalTo(120)
            $0.height.equalTo(104)
        }
        
        topDropdownButton.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            
            topDropdownLabel.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
        }
        
        dividerLine.snp.makeConstraints {
            $0.height.equalTo(0.7)
            $0.top.equalTo(topDropdownButton.snp.bottom)
            $0.centerY.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        bottomDropdownButton.snp.makeConstraints {
            $0.top.equalTo(dividerLine.snp.bottom)
            $0.bottom.horizontalEdges.equalToSuperview()
            
            bottomDropdownLabel.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
        }
    }
}
