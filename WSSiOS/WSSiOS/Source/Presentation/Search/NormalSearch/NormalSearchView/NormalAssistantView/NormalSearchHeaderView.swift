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
    private let searchBackgroundView = UIView()
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
        
        searchBackgroundView.do {
            $0.backgroundColor = .wssWhite
            $0.layer.cornerRadius = 14
            $0.layer.borderColor = UIColor.wssGray70.cgColor
            $0.layer.borderWidth = 1
        }
        
        searchTextField.do {
            $0.textColor = .wssBlack
            $0.font = .Label1
            $0.rightView = searchClearButton
            $0.rightViewMode = .whileEditing
            $0.tintColor = .wssBlack
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
        searchBackgroundView.addSubviews(searchTextField,
                                         searchButton)
        self.addSubviews(backButton,
                         searchBackgroundView)
    }
    
    private func setLayout() {
        backButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().inset(16)
            $0.size.equalTo(24)
        }
        
        searchTextField.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
        }
        
        searchButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(searchTextField.snp.trailing).offset(15)
            $0.trailing.equalToSuperview().inset(15)
            $0.size.equalTo(25)
        }
        
        searchBackgroundView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(2)
            $0.leading.equalTo(backButton.snp.trailing).offset(16)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(42)
            $0.bottom.equalToSuperview().inset(11)
        }
    }
}
