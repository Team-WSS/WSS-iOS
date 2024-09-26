//
//  FeedEditView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 6/29/24.
//

import UIKit

import SnapKit
import Then

final class FeedEditView: UIView {
    
    //MARK: - Components
    
    let backButton = UIButton()
    let completeButton = UIButton()
    let scrollView = UIScrollView()
    private let stackView = UIStackView()
    let feedEditCategoryView = FeedEditCategoryView()
    let feedEditContentView = FeedEditContentView()
    let feedEditNovelConnectView = FeedEditNovelConnectView()
    let feedEditConnectedNovelView = FeedEditConnectedNovelView()
    
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
            $0.tintColor = .wssBlack
        }
        
        completeButton.do {
            $0.setButtonAttributedTitle(text: StringLiterals.FeedEdit.complete, font: .Title2, color: .wssPrimary100)
            $0.isEnabled = false
        }
        
        scrollView.do {
            $0.contentInsetAdjustmentBehavior = .never
            $0.showsVerticalScrollIndicator = false
            $0.contentInset = UIEdgeInsets(top: 14.0, left: 0.0, bottom: 80.0, right: 0.0)
        }
        
        stackView.do {
            $0.alignment = .fill
            $0.axis = .vertical
            $0.spacing = 42
        }
    }
    
    private func setHierarchy() {
        self.addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubviews(feedEditCategoryView,
                                      feedEditContentView,
                                      feedEditNovelConnectView,
                                      feedEditConnectedNovelView)
    }
    
    private func setLayout() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(UIScreen.main.bounds.width)
            
            stackView.do {
                $0.setCustomSpacing(12, after: feedEditNovelConnectView)
            }
        }
    }
    
    //MARK: - Custom Method
    
    func enableCompleteButton(isAbled: Bool) {
        completeButton.do {
            $0.setButtonAttributedTitle(text: StringLiterals.FeedEdit.complete, font: .Title2, color: isAbled ? .wssPrimary100 : .wssGray200)
            $0.isEnabled = isAbled
        }
    }
}
