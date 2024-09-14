//
//  FeedNovelConnectSearchBarView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 8/17/24.
//

import UIKit

import SnapKit
import Then

final class FeedNovelConnectSearchBarView: UIView {
    
    //MARK: - Components
    
    let titleTextField = UITextField()
    let searchButton = UIButton()
    
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
        titleTextField.do {
            $0.becomeFirstResponder()
            $0.returnKeyType = .done
            $0.autocorrectionType = .no
            $0.spellCheckingType = .no
            $0.tintColor = .black
            $0.backgroundColor = .white
            $0.textColor = .wssBlack
            $0.font = .Label1
            $0.layer.cornerRadius = 14
            $0.layer.borderColor = UIColor.wssGray70.cgColor
            $0.layer.borderWidth = 1
            $0.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
            $0.rightView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 46.0, height: 0.0))
            $0.leftViewMode = .always
            $0.rightViewMode = .always
        }
        
        searchButton.do {
            $0.setImage(.icSearch.withRenderingMode(.alwaysTemplate), for: .normal)
            $0.tintColor = .wssGray300
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(titleTextField,
                         searchButton)
    }
    
    private func setLayout() {
        titleTextField.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(42)
        }
        
        searchButton.snp.makeConstraints {
            $0.trailing.equalTo(titleTextField.snp.trailing).offset(-10)
            $0.centerY.equalTo(titleTextField.snp.centerY)
            $0.size.equalTo(36)
        }
    }
}
