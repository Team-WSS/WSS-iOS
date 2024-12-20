//
//  MyPageInfoView.swift
//  WSSiOS
//
//  Created by 신지원 on 1/17/24.
//

import UIKit

import SnapKit
import Then

final class MyPageInfoView: UIView {
    
    //MARK: - Components
    
    private let dividerView = UIView()
    private let divider1View = UIView()
    private let divider2View = UIView()
    private let nickNameLabel = UILabel()
    public let userNickNameLabel = UILabel()
    private let emailLabel = UILabel()
    public let userEmailLabel = UILabel()
    private let secessionLabel = UILabel()
    private let divider3View = UIView()
    
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
        
        [dividerView, divider1View, divider2View, divider3View].forEach {
            $0.backgroundColor = .wssGray50
        }
        
        [nickNameLabel, emailLabel, secessionLabel].forEach {
            $0.textColor = .wssBlack
            $0.font = .Body1
        }
        
        [userNickNameLabel,userEmailLabel].forEach {
            $0.textColor = .wssGray200
            $0.font = .Body2
        }
        
        //데모데이 기준 숨김처리
        
        [emailLabel, secessionLabel,divider2View, divider3View, userEmailLabel].forEach {
            $0.isHidden = true
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(dividerView,
                         nickNameLabel,
                         userNickNameLabel,
                         divider1View,
                         emailLabel,
                         userEmailLabel,
                         divider2View,
                         secessionLabel,
                         divider3View)
    }
    
    private func setLayout() {
        dividerView.snp.makeConstraints() {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.width.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        nickNameLabel.snp.makeConstraints() {
            $0.top.equalTo(dividerView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(20)
        }
        
        userNickNameLabel.snp.makeConstraints() {
            $0.top.equalTo(nickNameLabel.snp.bottom)
            $0.leading.equalToSuperview().inset(20)
        }
        
        divider1View.snp.makeConstraints() {
            $0.top.equalTo(userNickNameLabel.snp.bottom).offset(20)
            $0.width.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        emailLabel.snp.makeConstraints() {
            $0.top.equalTo(divider1View.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(20)
        }
        
        userEmailLabel.snp.makeConstraints() {
            $0.top.equalTo(emailLabel.snp.bottom)
            $0.leading.equalToSuperview().inset(20)
        }
        
        divider2View.snp.makeConstraints() {
            $0.top.equalTo(userEmailLabel.snp.bottom).offset(20)
            $0.width.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        secessionLabel.snp.makeConstraints() {
            $0.top.equalTo(divider2View.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(20)
        }
        
        divider3View.snp.makeConstraints() {
            $0.top.equalTo(secessionLabel.snp.bottom).offset(20)
            $0.width.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    //MARK: - Data
    
    func bindData(_ data: String) {
        nickNameLabel.text = "닉네임"
        userNickNameLabel.text = data
        emailLabel.text = "이메일"
        userEmailLabel.text = ""
        secessionLabel.text = "회원탈퇴"
    }
}
