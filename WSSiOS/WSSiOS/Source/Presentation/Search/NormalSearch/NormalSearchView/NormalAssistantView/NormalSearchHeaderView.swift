//
//  NormalSearchHeaderView.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/27/24.
//

import UIKit

import SnapKit
import Then

final class NormalSearchHeaderView: UIView {
    
    //MARK: - Components
    
    let backButton = UIButton()
    let searchTextField = UITextField()
    let searchClearButton = UIButton()
    let searchButton = UIButton()
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI
    
    private func setUI() {
        backButton.do {
            $0.setImage(.icNavigateLeft.withTintColor(.wssBlack), for: .normal)
        }
        
        searchTextField.do {
            $0.returnKeyType = .done
            $0.autocorrectionType = .no
            $0.spellCheckingType = .no
            $0.tintColor = .wssBlack
            $0.backgroundColor = .wssGray50
            $0.textColor = .wssBlack
            $0.placeholder = StringLiterals.NovelReview.KeywordSearch.placeholder
            $0.font = .Body4
            $0.layer.cornerRadius = 14
            $0.layer.borderColor = UIColor.wssGray70.cgColor
            $0.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
            $0.rightView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 82.0, height: 0.0))
            $0.leftViewMode = .always
            $0.rightViewMode = .always
        }
        
        searchClearButton.do {
            $0.setImage(.icSearchCancel, for: .normal)
        }
        
        searchButton.do {
            $0.setImage(.icSearch.withRenderingMode(.alwaysOriginal).withTintColor(.wssGray300), for: .normal)
            $0.contentMode = .scaleAspectFit
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(backButton,
                         searchTextField,
                         searchClearButton,
                         searchButton)
    }
    
    private func setLayout() {
        backButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().inset(6)
            $0.size.equalTo(44)
        }
        
        searchTextField.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.top)
            $0.leading.equalTo(backButton.snp.trailing).offset(6)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(42)
            $0.bottom.equalToSuperview().inset(12)
        }
        
        searchClearButton.snp.makeConstraints {
            $0.trailing.equalTo(searchButton.snp.leading)
            $0.centerY.equalTo(searchTextField.snp.centerY)
            $0.size.equalTo(36)
        }
        
        searchButton.snp.makeConstraints {
            $0.trailing.equalTo(searchTextField.snp.trailing).offset(-10)
            $0.centerY.equalTo(searchTextField.snp.centerY)
            $0.size.equalTo(36)
        }
    }
    
    // MARK: - Custom Method
    
    func updateSearchTextField(isEditing: Bool) {
        searchTextField.do {
            $0.backgroundColor = isEditing ? .wssWhite : .wssGray50
            $0.layer.borderWidth = isEditing ? 1 : 0
        }
    }
}
