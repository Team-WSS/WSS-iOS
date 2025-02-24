//
//  FeedListContentView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 9/27/24.
//

import UIKit

import SnapKit
import Then

final class FeedListContentView: UIView {

    //MARK: - Components
    
    private let contentLabel = UILabel()
    
    // MARK: - Life Cycle
    
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
        contentLabel.do {
            $0.numberOfLines = 5
        }
    }
    
    private func setHierarchy() {
        self.addSubview(contentLabel)
    }
    
    private func setLayout() {
        contentLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    //MARK: - Data
    
    func bindData(feedContent: String, isSpoiler: Bool) {
        contentLabel.applyWSSFont(.body2, with: feedContent)
        contentLabel.do {
            $0.applyWSSFont(.body2, with: isSpoiler ? StringLiterals.NovelDetail.Feed.Cell.isSpoiler : feedContent)
            $0.textColor = isSpoiler ? .wssSecondary100 : .wssBlack
            $0.lineBreakMode = .byTruncatingTail
            $0.lineBreakStrategy = .hangulWordPriority
        }
    }
}
