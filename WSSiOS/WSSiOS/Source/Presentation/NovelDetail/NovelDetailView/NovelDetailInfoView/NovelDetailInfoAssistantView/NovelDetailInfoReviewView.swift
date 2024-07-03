//
//  NovelDetailInfoReviewView.swift
//  WSSiOS
//
//  Created by 이윤학 on 7/1/24.
//

import UIKit

import SnapKit
import Then

final class NovelDetailInfoReviewView: UIView {
    
    //MARK: - UI Components
    
    private let titleLabel = UILabel()
    private let attractivePointView = NovelDetailInfoReviewAttractivePointView()
    
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
        self.do {
            $0.backgroundColor = .wssWhite
        }
        
        titleLabel.do {
            $0.applyWSSFont(.title1,
                            with: StringLiterals.NovelDetail.Info.attractivePoints)
            $0.textColor = .wssBlack
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(titleLabel,
                         attractivePointView)
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(35)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        attractivePointView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(15)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(40)
            $0.height.equalTo(55)
        }
    }
    
    //MARK: - Data
    
    func bindData(_ data: NovelDetailInfoResult) {
        attractivePointView.bindData(data)
    }
}
