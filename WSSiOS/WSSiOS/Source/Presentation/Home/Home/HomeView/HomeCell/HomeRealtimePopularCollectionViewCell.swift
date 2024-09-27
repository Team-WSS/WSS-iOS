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
    
    //MARK: - Properties
    
    var onFeedViewTapped: ((String) -> Void)?
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setHierarchy()
        setLayout()
        setupTapGesture()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI
    
    private func setHierarchy() {
        self.addSubviews(firstFeedView, secondFeedView, thirdFeedView)
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
    
    private func setupTapGesture() {
        let feedViews = [firstFeedView, secondFeedView, thirdFeedView]
        
        for (index, feedView) in feedViews.enumerated() {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(feedViewTapped(_:)))
            feedView.addGestureRecognizer(tapGesture)
            feedView.isUserInteractionEnabled = true
            feedView.tag = index
        }
    }
    
    @objc private func feedViewTapped(_ sender: UITapGestureRecognizer) {
        guard let feedView = sender.view, let feedId = feedView.accessibilityIdentifier else { return }
        onFeedViewTapped?(feedId)
    }
    
    func bindData(data: [RealtimePopularFeed]) {
        let feedViews = [firstFeedView, secondFeedView, thirdFeedView]
        
        for (index, feedView) in feedViews.enumerated() {
            if data.indices.contains(index) {
                feedView.bindData(data: data[index])
                feedView.isHidden = false
                feedView.accessibilityIdentifier = String(data[index].feedId)
            } else {
                feedView.isHidden = true
            }
        }
    }
}
