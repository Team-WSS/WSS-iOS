//
//  MemoReadContentView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 1/13/24.
//

import UIKit

import SnapKit
import Then

final class MemoReadContentView: UIView {

    // MARK: - UI Components
    
    private let dividerView = UIView()
    private let dateLabel = UILabel()
    public let deleteButton = UIButton()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    public let memoContentLabel = UILabel()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierachy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - set UI
    
    private func setUI() {
        self.backgroundColor = .white
        
        dividerView.do {
            $0.backgroundColor = .Gray70
        }
        
        dateLabel.do {
            $0.textColor = .Gray200
            $0.font = .Label1
        }
        
        deleteButton.do {
            $0.setImage(ImageLiterals.icon.Memo.delete, for: .normal)
        }
        
        memoContentLabel.do {
            $0.textColor = .Black
            $0.font = .Body1
            $0.numberOfLines = 0
            $0.lineBreakStrategy = .hangulWordPriority
        }
    }
    
    // MARK: - set Hierachy
    
    private func setHierachy() {
        self.addSubviews(dividerView,
                         dateLabel,
                         deleteButton,
                         scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(memoContentLabel)
    }
    
    // MARK: - set Layout
    
    private func setLayout() {
        dividerView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(0.7)
        }
        
        dateLabel.snp.makeConstraints {
            $0.centerY.equalTo(deleteButton.snp.centerY)
            $0.leading.equalToSuperview().inset(20)
        }
        
        deleteButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(14)
            $0.trailing.equalToSuperview().inset(20)
            $0.size.equalTo(24)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(deleteButton.snp.bottom).offset(23)
            $0.leading.trailing.bottom.equalToSuperview().inset(20)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.width.equalToSuperview()
        }
        
        memoContentLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func updateTextViewConstraint(keyboardHeight: CGFloat) {
        self.memoContentLabel.snp.updateConstraints {
            $0.bottom.equalToSuperview().inset(keyboardHeight + 20)
        }
    }
    
    func bindData(date: String, memoContent: String) {
        self.dateLabel.text = date
        self.memoContentLabel.text = memoContent
    }
}
