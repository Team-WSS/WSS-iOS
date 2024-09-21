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
    
    let firstFeedView = HomeRealTimePopularFeedView()
    let secondFeedView = HomeRealTimePopularFeedView()
    let thirdFeedView = HomeRealTimePopularFeedView()
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setHierarchy()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI
    
    private func setHierarchy() {
        self.addSubviews(firstFeedView,
                         secondFeedView,
                         thirdFeedView)
    }
    
    private func setLayout() {
        firstFeedView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        secondFeedView.snp.makeConstraints {
            $0.top.equalTo(firstFeedView.snp.bottom).offset(40)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        thirdFeedView.snp.makeConstraints {
            $0.top.equalTo(secondFeedView.snp.bottom).offset(40)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
    
    func bindData(data: [RealtimePopularFeed]) {
        guard data.count == 3 else { return }
        
        firstFeedView.bindData(data: data[0])
        secondFeedView.bindData(data: data[1])
        thirdFeedView.bindData(data: data[2])
    }
}
