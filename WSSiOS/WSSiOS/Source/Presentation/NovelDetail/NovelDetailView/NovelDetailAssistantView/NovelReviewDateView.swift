//
//  NovelReviewDateView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 8/28/24.
//

import UIKit

import SnapKit
import Then

final class NovelReviewDateView: UIView {
    
    //MARK: - Components
    
    private let dateButton = UIButton()
    
    //MARK: - Life Cycle
    
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
        dateButton.do {
            $0.setButtonUnderlinedAttributedTitle(text: StringLiterals.NovelReview.Date.addDate, font: .Body4_2, color: .wssGray200)
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(dateButton)
    }
    
    private func setLayout() {
        dateButton.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(12.5)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
    }
}
