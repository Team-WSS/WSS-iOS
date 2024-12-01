//
//  MyPageActivyView.swift
//  WSSiOS
//
//  Created by 신지원 on 12/1/24.
//

import UIKit

import SnapKit
import Then

final class MyPageFeedView: UIView {
    
    // MARK: - Properties
    
    // MARK: - Components
    
    let myPageFeedTableView = UITableView(frame: .zero, style: .plain)
    let myPageFeedDetailButton = UIButton()
    let myPageFeedDetailButtonLabel = UILabel()
    
    private let myPagePrivateView = MyPagePrivateView()
    private let myPageFeedEmptyView = MyPageFeedEmptyView()
    
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
        
        myPageFeedTableView.do {
            $0.showsVerticalScrollIndicator = false
            $0.separatorStyle = .none
            $0.isScrollEnabled = false
            $0.isUserInteractionEnabled = true
        }
        
        myPageFeedDetailButton.do {
            $0.layer.cornerRadius = 8
            $0.layer.borderColor = UIColor.wssPrimary100.cgColor
            $0.layer.borderWidth = 1
            
            myPageFeedDetailButtonLabel.do {
                $0.applyWSSFont(.title2, with: StringLiterals.MyPage.Profile.activyButton)
                $0.textColor = .wssPrimary100
            }
        }
        
        myPagePrivateView.isHidden = true
        myPageFeedEmptyView.isHidden = true
    }
    
    private func setHierarchy() {
        self.addSubviews(myPageFeedTableView,
//                         myPageFeedDetailButton,
                         myPagePrivateView,
                         myPageFeedEmptyView)
//        myPageFeedDetailButton.addSubview(myPageFeedDetailButtonLabel)
    }
    
    private func setLayout() {
        myPageFeedTableView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(0)
        }
        
//        myPageFeedDetailButton.snp.makeConstraints {
//            $0.top.equalTo(myPageFeedTableView.snp.bottom)
//            $0.leading.trailing.equalToSuperview().inset(20)
//            $0.height.equalTo(48)
//        }
//
//        myPageFeedDetailButtonLabel.snp.makeConstraints {
//            $0.center.equalToSuperview()
//        }
        
        myPagePrivateView.snp.makeConstraints {
            $0.top.width.bottom.equalToSuperview()
            $0.height.equalTo(450)
        }
        
        myPageFeedEmptyView.snp.makeConstraints {
            $0.top.width.bottom.equalToSuperview()
            $0.height.equalTo(450)
        }
    }
    
    //MARK: - Data
    
    func isPrivateUserView(isPrivate: Bool, nickname: String) {
        if isPrivate {
            myPageFeedTableView.isHidden = true
            //            myPageFeedDetailButton.isHidden = true
            
            let text = nickname + StringLiterals.MyPage.Profile.privateLabel
            myPagePrivateView.isPrivateDescriptionLabel.do {
                $0.applyWSSFont(.body2, with: text)
                $0.textAlignment = .center
            }
        }
    }
    
    func isEmprtyView(isEmpty: Bool) {
            myPageFeedTableView.isHidden = isEmpty
//            myPageFeedDetailButton.isHidden = true
            
            myPageFeedEmptyView.isHidden = !isEmpty
    }
}
