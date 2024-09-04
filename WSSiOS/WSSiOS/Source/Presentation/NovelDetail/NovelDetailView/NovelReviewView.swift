//
//  NovelReviewView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 8/28/24.
//

import UIKit

import SnapKit
import Then

final class NovelReviewView: UIView {

    //MARK: - Components
    
    let backButton = UIButton()
    let completeButton = UIButton()
    let scrollView = UIScrollView()
    let stackView = UIStackView()
    let novelReviewStatusView = NovelReviewStatusView()
    let novelReviewRatingView = NovelReviewRatingView()
    
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
        self.do {
            $0.backgroundColor = .wssWhite
        }
        
        backButton.do {
            $0.setImage(.icNavigateLeft.withRenderingMode(.alwaysTemplate), for: .normal)
            $0.tintColor = .wssGray200
        }
        
        completeButton.do {
            $0.setButtonAttributedTitle(text: StringLiterals.NovelReview.Navigation.complete, font: .Title2, color: .wssGray200)
            $0.isEnabled = false
        }
        
        scrollView.do {
            $0.contentInsetAdjustmentBehavior = .never
            $0.showsVerticalScrollIndicator = false
        }
        
        stackView.do {
            $0.backgroundColor = .wssGray50
            $0.spacing = 1
            $0.alignment = .fill
            $0.axis = .vertical
        }
    }
    
    private func setHierarchy() {
        self.addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubviews(novelReviewStatusView,
                                      novelReviewRatingView)
    }
    
    private func setLayout() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalToSuperview()
        }
    }
    
    //MARK: - Custom Method
    
    func enableCompleteButton(isEnabled: Bool) {
        completeButton.do {
            $0.setButtonAttributedTitle(text: StringLiterals.NovelReview.Navigation.complete, font: .Title2, color: isEnabled ? .wssPrimary100 : .wssGray200)
            $0.isEnabled = isEnabled
        }
    }
}
