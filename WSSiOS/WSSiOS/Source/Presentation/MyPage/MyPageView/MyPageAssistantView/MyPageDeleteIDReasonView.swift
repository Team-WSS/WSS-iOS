//
//  MyPageDeleteIDReasonView.swift
//  WSSiOS
//
//  Created by 신지원 on 7/24/24.
//

import UIKit

import SnapKit
import Then

final class MyPageDeleteIDReasonView: UIView {
    
    //MARK: - Components
    
    private let titleLabel = UILabel()
    var tableView = UITableView(frame: .zero, style: .plain)
    var textView = UITextView()
    var countLabel = UILabel()
    private let countLimitLabel = UILabel()
    
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
        self.backgroundColor = .wssWhite
        
        titleLabel.do {
            $0.textColor = .wssBlack
            $0.makeAttribute(with: StringLiterals.MyPage.DeleteID.reasonTitle)?
                .partialColor(color: .wssPrimary100, rangeString: "탈퇴사유")
                .lineHeight(1.17)
                .kerning(kerningPixel: -1.2)
                .applyAttribute()
            $0.font = .HeadLine1
        }
        
        tableView.do {
            $0.isScrollEnabled = false
            $0.showsVerticalScrollIndicator = false
            $0.separatorStyle = .none
        }
        
        textView.do {
            $0.text = StringLiterals.MyPage.DeleteID.reasonPlaceHolder
            $0.font = .Body2
            $0.textColor = .wssGray200
            $0.backgroundColor = .wssGray50
            $0.layer.cornerRadius = 14
            $0.textContainerInset = UIEdgeInsets(top: 10, left: 16, bottom: 12, right: 16)
        }
        
        countLabel.do {
            $0.applyWSSFont(.label1, with: "0")
            $0.textColor = .wssGray300
        }
        
        countLimitLabel.do {
            $0.applyWSSFont(.label1, with: "/80")
            $0.textColor = .wssGray200
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(titleLabel,
                         tableView,
                         textView,
                         countLimitLabel,
                         countLabel)
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(44 * 5)
        }
        
        textView.snp.makeConstraints {
            $0.top.equalTo(tableView.snp.bottom).offset(2)
            $0.width.equalToSuperview()
            $0.height.equalTo(114)
        }
        
        countLimitLabel.snp.makeConstraints {
            $0.top.equalTo(textView.snp.bottom).offset(4)
            $0.trailing.equalToSuperview()
        }
        
        countLabel.snp.makeConstraints {
            $0.top.equalTo(countLimitLabel.snp.top)
            $0.trailing.equalTo(countLimitLabel.snp.leading)
        }
    }
}
