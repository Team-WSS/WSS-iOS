//
//  MyPageActivyView.swift
//  WSSiOS
//
//  Created by 신지원 on 12/1/24.
//

import UIKit

import SnapKit
import Then

final class UserPageFeedView: UIView {
    
    // MARK: - Components
    
    private let stackView = UIStackView()
    
    let userPageFeedTableView = FeedListView()
    
    private let showMoreActivityButtonView = UIView()
    let userPageFeedDetailButton = UIButton()
    private let userPageFeedDetailButtonLabel = UILabel()

    private let userPagePrivateView = UserPagePrivateView()
    private let userPageFeedEmptyView = UserPageFeedEmptyView()
    
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
    
    private func setUI() {
        self.backgroundColor = .wssWhite
        
        stackView.do {
            $0.axis = .vertical
        }
        
        userPageFeedDetailButton.do {
            $0.layer.cornerRadius = 8
            $0.layer.borderColor = UIColor.wssPrimary100.cgColor
            $0.layer.borderWidth = 1
            
            userPageFeedDetailButtonLabel.do {
                $0.applyWSSFont(.title2, with: StringLiterals.MyPage.Profile.activityButton)
                $0.textColor = .wssPrimary100
            }
        }
        
        userPagePrivateView.isHidden = true
        userPageFeedEmptyView.isHidden = true
    }
    
    private func setHierarchy() {
        self.addSubview(stackView)
        stackView.addArrangedSubviews(userPageFeedTableView,
                                      showMoreActivityButtonView,
                                      userPagePrivateView,
                                      userPageFeedEmptyView)
        showMoreActivityButtonView.addSubview(userPageFeedDetailButton)
        userPageFeedDetailButton.addSubview(userPageFeedDetailButtonLabel)
    }
    
    private func setLayout() {
        stackView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(40)
        }
        
        userPageFeedDetailButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(28)
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(48)
        }
        
        userPageFeedDetailButtonLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        userPagePrivateView.snp.makeConstraints {
            $0.height.equalTo(450)
        }
        
        userPageFeedEmptyView.snp.makeConstraints {
            $0.height.equalTo(450)
        }
    }
    
    //MARK: - Data
    
    func isPrivateUserPage(nickname: String) {
        userPagePrivateView.isHidden = false
        
        [userPageFeedTableView,
         showMoreActivityButtonView,
         userPageFeedEmptyView].forEach { view in
            view.isHidden = true
        }
        let text = nickname + StringLiterals.MyPage.Profile.privateLabel
        userPagePrivateView.bindData(nickname: text)
    }
    
    func isEmptyFeed() {
        userPageFeedEmptyView.isHidden = false
        
        [userPageFeedTableView,
         showMoreActivityButtonView].forEach { view in
            view.isHidden = true
        }
    }
    
    func showMoreButton(isShow: Bool) {
        showMoreActivityButtonView.isHidden = !isShow
        self.stackView.layoutIfNeeded()
    }
}
