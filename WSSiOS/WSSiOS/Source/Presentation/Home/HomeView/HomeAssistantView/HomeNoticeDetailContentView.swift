//
//  HomeNoticeDetailContentView.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 7/6/24.
//

import UIKit

import SnapKit
import Then

final class HomeNoticeDetailContentView: UIView {
    
    //MARK: - UI Components
    
    private let stackView = UIStackView()
    private let noticeTitleLabel = UILabel()
    private let createdDateLabel = UILabel()
    private let noticeContentLabel = UILabel()
    
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
        stackView.do {
            $0.axis = .vertical
        }
        
        noticeTitleLabel.do {
            $0.textColor = .wssBlack
        }
        
        createdDateLabel.do {
            $0.textColor = .wssGray200
        }
        
        noticeContentLabel.do {
            $0.textColor = .wssBlack
        }
    }
    
    private func setHierarchy() {
        self.addSubview(stackView)
        stackView.addArrangedSubviews(noticeTitleLabel,
                                      createdDateLabel,
                                      noticeContentLabel)
    }
    
    private func setLayout() {
        stackView.setCustomSpacing(10, after: noticeTitleLabel)
        stackView.setCustomSpacing(44, after: createdDateLabel)
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(40)
        }
    }
    
    func bindData(data: Notice) {
        noticeTitleLabel.do {
            $0.applyWSSFont(.headline1, with: data.noticeTitle)
            $0.numberOfLines = 0
        }
        createdDateLabel.applyWSSFont(.body5, with: data.createdDate)
        noticeContentLabel.do {
            $0.applyWSSFont(.body2, with: data.noticeContent)
            $0.numberOfLines = 0
            $0.lineBreakStrategy = .hangulWordPriority
        }
    }
}
