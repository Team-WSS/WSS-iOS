//
//  MyPageDeleteIDReasonView.swift
//  WSSiOS
//
//  Created by 신지원 on 9/9/24.
//

import UIKit

import SnapKit
import Then

final class MyPageDeleteIDReasonView: UIView {

    //MARK: - Components
    
    private let reasonTitleLabel = UILabel()
    var reasonTableView = UITableView(frame: .zero, style: .plain)
    var reasonTextView = UITextView()
    private var reasonTextViewPlaceholder = UILabel()
    var reasonCountLabel = UILabel()
    private let reasonCountLimitLabel = UILabel()
    
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
        reasonTitleLabel.do {
            $0.font = .HeadLine1
            $0.textColor = .wssBlack
            $0.makeAttribute(with: StringLiterals.MyPage.DeleteID.reasonTitle)?
                .lineHeight(1.4)
                .kerning(kerningPixel: -1.2)
                .partialColor(color: .wssPrimary100, rangeString: StringLiterals.MyPage.DeleteID.reasonTitleColor)
                .applyAttribute()
        }
        
        reasonTableView.do {
            $0.isScrollEnabled = false
            $0.showsVerticalScrollIndicator = false
            $0.separatorStyle = .none
        }
        
        reasonTextView.do {
            $0.font = .Body2
            $0.textColor = .wssBlack
            $0.backgroundColor = .wssGray50
            $0.layer.cornerRadius = 14
            $0.textContainerInset = UIEdgeInsets(top: 10, left: 16, bottom: 12, right: 16)
            $0.spellCheckingType = .no
            $0.autocorrectionType = .no
            $0.autocapitalizationType = .none
        }
        
        reasonTextViewPlaceholder.do {
            $0.applyWSSFont(.body2, with: StringLiterals.MyPage.DeleteID.reasonPlaceHolder)
            $0.textColor = .wssGray200
        }
        
        reasonCountLabel.do {
            $0.applyWSSFont(.label1, with: "0")
            $0.textColor = .wssGray300
        }
        
        reasonCountLimitLabel.do {
            $0.applyWSSFont(.label1, with: "/" + String(MyPageDeleteIDViewModel.textViewMaxLimit))
            $0.textColor = .wssGray200
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(reasonTitleLabel,
                         reasonTableView,
                         reasonTextView,
                         reasonCountLimitLabel,
                         reasonCountLabel)
        reasonTextView.addSubview(reasonTextViewPlaceholder)
    }
    
    private func setLayout() {
        reasonTitleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        reasonTableView.snp.makeConstraints {
            $0.top.equalTo(reasonTitleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(44 * 5)
        }
        
        reasonTextView.snp.makeConstraints {
            $0.top.equalTo(reasonTableView.snp.bottom).offset(2)
            $0.width.equalToSuperview()
            $0.height.equalTo(114)
            
            reasonTextViewPlaceholder.snp.makeConstraints {
                $0.top.equalToSuperview().inset(10)
                $0.leading.trailing.equalToSuperview().inset(16)
            }
        }
        
        reasonCountLimitLabel.snp.makeConstraints {
            $0.top.equalTo(reasonTextView.snp.bottom).offset(4)
            $0.trailing.equalToSuperview()
        }
        
        reasonCountLabel.snp.makeConstraints {
            $0.top.equalTo(reasonCountLimitLabel.snp.top)
            $0.trailing.equalTo(reasonCountLimitLabel.snp.leading)
            $0.bottom.equalToSuperview()
        }
    }
    
    //MARK: - Data
    
    func bindTextCount(count: Int) {
        reasonCountLabel.do {
            $0.applyWSSFont(.label1, with: String(count))
        }
    }
    
    func bindText(text: String) {
        reasonTextView.do {
            $0.text = text
        }
    }
    
    //MARK: - Custom Method
    
    func placeholderIsHidden(isHidden: Bool) {
        reasonTextViewPlaceholder.isHidden = isHidden
    }
}
