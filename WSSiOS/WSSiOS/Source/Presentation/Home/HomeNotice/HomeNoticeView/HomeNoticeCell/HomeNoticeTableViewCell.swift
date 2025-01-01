//
//  HomeNoticeTableViewCell.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/12/24.
//

import UIKit

import SnapKit
import Then

final class HomeNoticeTableViewCell: UITableViewCell {
    
    //MARK: - UI Components
    
    private var adminProfileImageView = UIImageView()
    
    private var contentStackView = UIStackView()
    private var titleLabel = UILabel()
    private var contentLabel = UILabel()
    private var dateLabel = UILabel()
    
    //MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
            $0.selectionStyle = .none
            $0.backgroundColor = .wssWhite
        }
        
        adminProfileImageView.do {
            $0.image = .imgAlertNews
            $0.layer.cornerRadius = 11.25
            $0.clipsToBounds = true
        }
        
        contentStackView.do {
            $0.axis = .vertical
        }
        
        titleLabel.do {
            $0.textColor = .wssBlack
        }
        
        contentLabel.do {
            $0.textColor = .wssGray200
        }
        
        dateLabel.do {
            $0.textColor = .wssGray200
        }
    }
    
    private func setHierarchy() {
        contentStackView.addArrangedSubviews(titleLabel,
                                             contentLabel,
                                             dateLabel)
        self.addSubviews(adminProfileImageView,
                         contentStackView)
    }
    
    private func setLayout() {
        adminProfileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(20)
            $0.size.equalTo(36)
        }
        
        contentStackView.do {
            $0.setCustomSpacing(2, after: titleLabel)
            $0.setCustomSpacing(14, after: contentLabel)
        }
        
        contentStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalTo(adminProfileImageView.snp.trailing).offset(14)
            $0.trailing.equalToSuperview().inset(20)
        }
    }
    
    func bindData(data: Notice) {
        self.titleLabel.do {
            $0.applyWSSFont(.title2, with: data.noticeTitle)
            $0.lineBreakMode = .byTruncatingTail
            $0.numberOfLines = 1
        }
        
        self.contentLabel.do {
            $0.applyWSSFont(.body5, with: data.noticeContent)
            $0.lineBreakMode = .byTruncatingTail
            $0.numberOfLines = 1
        }

        self.dateLabel.do {
            $0.applyWSSFont(.body5, with: data.createdDate)
        }
    }
}
