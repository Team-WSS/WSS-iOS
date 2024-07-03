//
//  TrashNovelDetailMemoTableViewCell.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 1/11/24.
//

import UIKit

import SnapKit
import Then

final class TrashNovelDetailMemoTableViewCell: UITableViewCell {
    
    //MARK: - Components
    
    private let leftDividerView = UIView()
    private let rightDividerView = UIView()
    private let memoDateLabel = UILabel()
    private let memoContentLabel = UILabel()
    

    //MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
        
        leftDividerView.do {
            $0.backgroundColor = .wssGray70
        }
        
        rightDividerView.do {
            $0.backgroundColor = .wssGray70
        }
        
        memoDateLabel.do {
            $0.font = .Label2
            $0.textColor = .wssGray200
        }
        
        memoContentLabel.do {
            $0.font = .Body2
            $0.textColor = .wssBlack
            $0.numberOfLines = 5
        }
    }
    
    private func setHierarchy() {
        self.contentView.addSubviews(leftDividerView,
                                     rightDividerView,
                                     memoDateLabel,
                                     memoContentLabel)
    }
    
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
    
    //MARK: - Data
    
    func bindData(memo: UserNovelMemo) {
        self.memoDateLabel.text = memo.createdDate
        self.memoContentLabel.do {
            $0.makeAttribute(with: memo.memoContent)?
                .lineSpacing(spacingPercentage: 150)
                .kerning(kerningPixel: -0.6)
                .applyAttribute()
            $0.lineBreakMode = .byTruncatingTail
            $0.lineBreakStrategy = .hangulWordPriority
        }
    }
}
