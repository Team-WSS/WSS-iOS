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
            $0.applyWSSFont(.headline1, with: "리뷰 기능 변경 관련 공지")
            $0.textColor = .wssBlack
        }
        
        createdDateLabel.do {
            $0.applyWSSFont(.body5, with: "2024.11.16")
            $0.textColor = .wssGray200
        }
        
        noticeContentLabel.do {
            $0.applyWSSFont(.body2, with: "156번은 연장냥(Chicken Cat)이라는 닭 코스튬을 입은 모습의 냥코가 존재한다, 8.0 이전까지 데이터로만 존재하다가 이후 삭제되었다. 183번 냥코 자리에 EX 캐릭터인데")
            $0.textColor = .wssBlack
            $0.numberOfLines = 0
            $0.lineBreakStrategy = .hangulWordPriority
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
}
