//
//  FeedDetailReplyView.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 6/24/24.
//

import UIKit

import SnapKit
import Then

final class FeedDetailReplyView: UIView {
    
    //MARK: - UI Components
    
    private let replyTitleStackView = UIStackView()
    private let replyTitleLabel = UILabel()
    let replyCountLabel = UILabel()
    let replyTableView = UITableView(frame: .zero, style: .plain)
    
    private let testView = FeedDetailReplyTableViewCell()
    
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
        replyTitleStackView.do {
            $0.axis = .horizontal
            $0.spacing = 2
        }
        
        replyTitleLabel.do {
            $0.applyWSSFont(.title2, with: StringLiterals.FeedDetail.reply)
            $0.textColor = .wssBlack
        }
        
        replyCountLabel.do {
            $0.textColor = .wssPrimary100
        }
        
        replyTableView.do {
            $0.showsVerticalScrollIndicator = false
            $0.separatorStyle = .none
            $0.contentInset.top = 24
            $0.contentInset.bottom = 24
        }
    }
    
    private func setHierarchy() {
        replyTitleStackView.addArrangedSubviews(replyTitleLabel,
                                                replyCountLabel)
        self.addSubviews(replyTitleStackView,
                         replyTableView)
    }
    
    private func setLayout() {
        replyTitleStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(20)
        }
        
        replyTableView.snp.makeConstraints {
            $0.top.equalTo(replyTitleStackView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
        }
    }
    
    func bindData(commentCount: Int) {
        replyCountLabel.applyWSSFont(.title2, with: String(commentCount))
    }
}
