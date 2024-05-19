//
//  FeedContentView.swift
//  WSSiOS
//
//  Created by 신지원 on 5/15/24.
//

import UIKit

import SnapKit
import Then

final class FeedDetailContentView: UIView {
    
    //MARK: - Components
    
    let detailContentLabel = UILabel()
    
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
        self.do {
            $0.backgroundColor = .wssWhite
        }
    }
    
    private func setHierarchy() {
        addSubview(detailContentLabel)
    }
    
    private func setLayout() {
        detailContentLabel.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.trailing.lessThanOrEqualToSuperview()
        }
    }
    
    func bindData(content: String, isSpolier: Bool) {
        detailContentLabel.text = isSpolier ? StringLiterals.Feed.spoilerText : content
        detailContentLabel.textColor = isSpolier ? .Secondary100 : .wssBlack
        
        detailContentLabel.do {
            $0.font = .Body2
            $0.textAlignment = .natural
            $0.numberOfLines = 5
            $0.lineBreakMode = .byTruncatingTail
            $0.lineBreakStrategy = .hangulWordPriority
        }
    }
}
