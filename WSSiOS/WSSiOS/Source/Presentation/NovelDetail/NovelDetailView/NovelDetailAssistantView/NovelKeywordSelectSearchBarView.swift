//
//  NovelKeywordSelectSearchBarView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 9/17/24.
//

import UIKit

import SnapKit
import Then

final class NovelKeywordSelectSearchBarView: UIView {
    
    //MARK: - Components
    
    let keywordTextField = UITextField()
    let searchCancelButton = UIButton()
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
        keywordTextField.do {
            $0.becomeFirstResponder()
            $0.returnKeyType = .done
            $0.autocorrectionType = .no
            $0.spellCheckingType = .no
            $0.tintColor = .black
            $0.backgroundColor = .wssGray50
            $0.textColor = .wssBlack
            $0.font = .Body4
            $0.layer.cornerRadius = 14
            $0.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
            $0.rightView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 82.0, height: 0.0))
            $0.leftViewMode = .always
            $0.rightViewMode = .always
        }
        
        searchCancelButton.do {
            $0.setImage(.icSearchCancel, for: .normal)
        }
        
        searchButton.do {
            $0.setImage(.icSearch.withRenderingMode(.alwaysTemplate), for: .normal)
            $0.tintColor = .wssGray300
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(keywordTextField,
                         searchCancelButton,
                         searchButton)
    }
    
    private func setLayout() {
        keywordTextField.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(42)
        }
        
        searchCancelButton.snp.makeConstraints {
            $0.trailing.equalTo(searchButton.snp.leading)
            $0.centerY.equalTo(keywordTextField.snp.centerY)
            $0.size.equalTo(36)
        }
        
        searchButton.snp.makeConstraints {
            $0.trailing.equalTo(keywordTextField.snp.trailing).offset(-10)
            $0.centerY.equalTo(keywordTextField.snp.centerY)
            $0.size.equalTo(36)
        }
    }
}
