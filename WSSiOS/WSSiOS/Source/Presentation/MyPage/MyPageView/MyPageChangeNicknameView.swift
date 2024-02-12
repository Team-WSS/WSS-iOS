//
//  MyPageChangeNicknameView.swift
//  WSSiOS
//
//  Created by 신지원 on 1/12/24.
//

import UIKit

import SnapKit
import Then

final class MyPageChangeNicknameView: UIView {
    
    //MARK: - Components
    
    private let dividerView = UIView()
    private let nicknameLabel = UILabel()
    public lazy var changeNicknameTextField = UITextField()
    public lazy var setClearButton = UIButton(type: .custom)
    public lazy var textFieldUnderBarView = UIView()
    public lazy var countNicknameLabel = UILabel()
    
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
        
        dividerView.do {
            $0.backgroundColor = .wssGray50
        }
        
        nicknameLabel.do {
            $0.text = StringLiterals.MyPage.ChangeNickname.nickname
            $0.font = .Body2
            $0.textColor = .wssGray200
        }
        
        changeNicknameTextField.do {
            $0.font = .Body1
            $0.textColor = .wssBlack
            $0.borderStyle = .none
            $0.rightView = setClearButton
            $0.rightViewMode = .always
        }
        
        setClearButton.do {
            $0.setImage(.icSearchCancel, for: .normal)
            $0.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
            $0.imageView?.contentMode = .scaleAspectFill
        }
        
        textFieldUnderBarView.do {
            $0.backgroundColor = .wssGray200
        }
        
        countNicknameLabel.do {
            $0.text = "\(String(describing: changeNicknameTextField.text?.count))/10"
            $0.font = .Label1
            $0.textColor = .wssGray200
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(dividerView,
                         nicknameLabel,
                         changeNicknameTextField,
                         textFieldUnderBarView,
                         countNicknameLabel)
    }
    
    private func setLayout() {
        dividerView.snp.makeConstraints() {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.width.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        nicknameLabel.snp.makeConstraints() {
            $0.top.equalTo(dividerView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
        }
        
        changeNicknameTextField.snp.makeConstraints() {
            $0.top.equalTo(nicknameLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(41)
        }
        
        textFieldUnderBarView.snp.makeConstraints() {
            $0.bottom.equalTo(changeNicknameTextField.snp.bottom)
            $0.leading.equalTo(changeNicknameTextField.snp.leading)
            $0.width.equalTo(changeNicknameTextField.snp.width)
            $0.height.equalTo(1.3)
        }
        
        countNicknameLabel.snp.makeConstraints() {
            $0.top.equalTo(changeNicknameTextField.snp.bottom).offset(10)
            $0.trailing.equalTo(changeNicknameTextField.snp.trailing)
        }
    }
}
