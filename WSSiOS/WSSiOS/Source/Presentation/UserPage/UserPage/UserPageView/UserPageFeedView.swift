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
    private let paddingViewAfterButton = UIView()
    
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
        
        paddingViewAfterButton.do {
            $0.backgroundColor = .wssWhite
        }
        
        userPagePrivateView.isHidden = true
        userPageFeedEmptyView.isHidden = true
    }
    
    private func setHierarchy() {
        self.addSubview(stackView)
        stackView.addArrangedSubviews(userPageFeedTableView,
                                      showMoreActivityButtonView,
                                      paddingViewAfterButton,
                                      userPagePrivateView,
                                      userPageFeedEmptyView)
        showMoreActivityButtonView.addSubview(userPageFeedDetailButton)
        userPageFeedDetailButton.addSubview(userPageFeedDetailButtonLabel)
    }
    
    private func setLayout() {
        stackView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
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
        
        paddingViewAfterButton.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(40)
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
         paddingViewAfterButton,
         userPageFeedEmptyView].forEach { view in
            view.isHidden = true
        }
        let text = nickname + StringLiterals.MyPage.Profile.privateLabel
        userPagePrivateView.bindData(nickname: text)
    }
    
    func isEmptyView(isEmpty: Bool) {
        userPageFeedEmptyView.isHidden = !isEmpty
        
        [userPageFeedTableView,
         showMoreActivityButtonView,
         paddingViewAfterButton].forEach { view in
            view.do {
                $0.isHidden = isEmpty
            }
        }
    }
    
    func showMoreButton(isShow: Bool) {
        showMoreActivityButtonView.isHidden = !isShow
        paddingViewAfterButton.isHidden = !isShow
        
        if isShow {
            paddingViewAfterButton.snp.makeConstraints {
                $0.width.equalToSuperview()
                $0.height.equalTo(40)
            }
        } else {
            paddingViewAfterButton.snp.makeConstraints {
                $0.width.bottom.equalToSuperview()
                $0.height.greaterThanOrEqualTo(40)
            }
        }
        
        self.stackView.layoutIfNeeded()
    }
}
