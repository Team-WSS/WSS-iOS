//
//  NovelDetailMemoTableViewCell.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 1/11/24.
//

import UIKit

import SnapKit
import Then

final class NovelDetailMemoTableViewCell: UITableViewCell {

    static let identifier: String = "NovelDetailMemoTableViewCell"
    
    // MARK: - UI Components
    
    private let leftDividerView = UIView()
    private let rightDividerView = UIView()
    private let memoDateLabel = UILabel()
    private let memoContentLabel = UILabel()
    

    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
        setHierachy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - set UI
    
    private func setUI() {
        self.do {
            $0.backgroundColor = .white
        }
        
        leftDividerView.do {
            $0.backgroundColor = .Gray70
        }
        
        rightDividerView.do {
            $0.backgroundColor = .Gray70
        }
        
        memoDateLabel.do {
            $0.font = .Label2
            $0.textColor = .Gray200
        }
        
        memoContentLabel.do {
            $0.font = .Body2
            $0.textColor = .Black
            $0.numberOfLines = 5
            $0.lineBreakMode = .byTruncatingTail
            $0.lineBreakStrategy = .hangulWordPriority
        }
    }
    
    // MARK: - set Hierachy
    
    private func setHierachy() {
        self.contentView.addSubviews(leftDividerView,
                                     rightDividerView,
                                     memoDateLabel,
                                     memoContentLabel)
    }
    
    // MARK: - set Layout
    
    private func setLayout() {
        leftDividerView.snp.makeConstraints {
            $0.centerY.equalTo(memoDateLabel.snp.centerY)
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(memoDateLabel.snp.leading).offset(-8)
            $0.height.equalTo(1.5)
        }
        
        rightDividerView.snp.makeConstraints {
            $0.centerY.equalTo(memoDateLabel.snp.centerY)
            $0.trailing.equalToSuperview()
            $0.leading.equalTo(memoDateLabel.snp.trailing).offset(8)
            $0.height.equalTo(1.5)
        }
        
        memoDateLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview().inset(44)
        }
        
        memoContentLabel.snp.makeConstraints {
            $0.top.equalTo(memoDateLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(48)
        }
    }
    
    // MARK: - bind data
    
    func bindData(date: String, content: String) {
        self.memoDateLabel.text = date
        self.memoContentLabel.text = content
    }
}
