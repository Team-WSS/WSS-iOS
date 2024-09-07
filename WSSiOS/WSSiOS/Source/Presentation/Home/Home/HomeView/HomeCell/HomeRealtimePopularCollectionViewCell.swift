//
//  HomeRealtimePopularCollectionViewCell.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/22/24.
//

import UIKit

import SnapKit
import Then

final class HomeRealtimePopularCollectionViewCell: UICollectionViewCell {
    
    //MARK: - UI Components
    
    private let topDividerLine = UIView()
    private let bottomDividerLine = UIView()
    
    let firstFeedView = HomeRealTimePopularFeedView()
    let secondFeedView = HomeRealTimePopularFeedView()
    let thirdFeedView = HomeRealTimePopularFeedView()
    
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
    
    //MARK: - UI
    
    private func setUI() {
        self.do {
            $0.layer.borderColor = UIColor.wssGray70.cgColor
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 14
        }
        
        topDividerLine.do {
            $0.backgroundColor = .wssGray70
        }
        
        bottomDividerLine.do {
            $0.backgroundColor = .wssGray70
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(firstFeedView,
                         topDividerLine,
                         secondFeedView,
                         bottomDividerLine,
                         thirdFeedView)
    }
    
    private func setLayout() {
        self.snp.makeConstraints {
            $0.width.equalTo(335)
            $0.height.equalTo(414)
        }
        
        firstFeedView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        topDividerLine.snp.makeConstraints {
            $0.top.equalToSuperview().offset(138)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        secondFeedView.snp.makeConstraints {
            $0.top.equalTo(topDividerLine.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        bottomDividerLine.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(138)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        thirdFeedView.snp.makeConstraints {
            $0.top.equalTo(bottomDividerLine.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
    }
}
