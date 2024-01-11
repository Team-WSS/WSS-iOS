//
//  MyPageChangeNicknameView.swift
//  WSSiOS
//
//  Created by 신지원 on 1/12/24.
//

import UIKit

import SnapKit
import Then

class MyPageChangeNicknameView: UIView {
    
    //MARK: - UI Components
    
    private let nicknameLabel = UILabel()
    var changeNicknameTextField = UITextField()
    var setClearButton = UIButton(type: .custom)
    var textFieldUnderBarView = UIView()
    var countNicknameLabel = UILabel()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierachy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        self.backgroundColor = .White
        
        nicknameLabel.do {
            $0.text = "닉네임"
            $0.font = .Body2
            $0.textColor = .Gray200
        }
        
        changeNicknameTextField.do {
            $0.text = "김명진"
            $0.font = .Body1
            $0.textColor = .Black
            $0.borderStyle = .none
            $0.rightView = setClearButton
            $0.rightViewMode = .always
        }
        
        setClearButton.do {
            $0.setImage(ImageLiterals.icon.searchCancel, for: .normal)
            $0.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
            $0.imageView?.contentMode = .scaleAspectFill
        }
        
        textFieldUnderBarView.do {
            $0.backgroundColor = .Gray200
        }
        
        countNicknameLabel.do {
            $0.text = "\(changeNicknameTextField.text?.count)/10"
            $0.font = .Label1
            $0.textColor = .Gray200
        }
    }
    
    private func setHierachy() {
        self.addSubviews(nicknameLabel,
                         changeNicknameTextField,
                         textFieldUnderBarView,
                         countNicknameLabel)
    }
    
    private func setLayout() {
        nicknameLabel.snp.makeConstraints() {
            $0.top.leading.equalTo(safeAreaLayoutGuide).offset(20)
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
