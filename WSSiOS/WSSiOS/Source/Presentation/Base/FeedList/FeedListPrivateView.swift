//
//  FeedListPrivateView.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/1/25.
//

import UIKit

import SnapKit
import Then

final class FeedListPrivateView: UIView {
    
    //MARK: - Components
    
    private let lockImageView = UIImageView()
    private let privateFeedLabel = UILabel()
    
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
        lockImageView.do {
            $0.image = .icLock.withRenderingMode(.alwaysOriginal).withTintColor(.wssGray200)
        }
        
        privateFeedLabel.do {
            $0.applyWSSFont(.body4, with: StringLiterals.Feed.isPrivate)
            $0.textColor = .wssGray200
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(lockImageView,
                         privateFeedLabel)
    }
    
    private func setLayout() {
        lockImageView.snp.makeConstraints {
            $0.size.equalTo(18)
            $0.leading.centerY.equalToSuperview()
        }
        
        privateFeedLabel.snp.makeConstraints {
            $0.leading.equalTo(lockImageView.snp.trailing).offset(6)
            $0.verticalEdges.equalToSuperview().inset(10)
        }
    }
}
