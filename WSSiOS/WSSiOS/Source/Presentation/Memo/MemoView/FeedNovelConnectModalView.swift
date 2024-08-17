//
//  FeedNovelConnectModalView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 8/17/24.
//

import UIKit

import SnapKit
import Then

final class FeedNovelConnectModalView: UIView {
    
    //MARK: - Components
    
    let contentView = UIView()
    let closeButton = UIButton()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    let titleTextField = UITextField()
    let searchButton = UIButton()
    let connectNovelButton = UIButton()
    
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
        self.do {
            $0.backgroundColor = .black.withAlphaComponent(0.3)
        }
        
        contentView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 20
            $0.layer.maskedCorners = [.layerMinXMinYCorner,
                                      .layerMaxXMinYCorner]
        }
        
        closeButton.do {
            $0.setImage(.icCacelModal, for: .normal)
        }
        
        titleLabel.do {
            $0.applyWSSFont(.title1, with: "작품 연결하기")
            $0.textColor = .wssBlack
        }
        
        descriptionLabel.do {
            $0.applyWSSFont(.body2, with: "작성 중인 글과 관련된 웹소설을 선택하세요")
            $0.textColor = .wssGray200
        }
        
        titleTextField.do {
            $0.becomeFirstResponder()
            $0.returnKeyType = .done
            $0.autocapitalizationType = .none
            $0.autocorrectionType = .no
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
            $0.setImage(.icSearch, for: .normal)
        }
    }
    
    private func setHierarchy() {
        self.addSubview(contentView)
        contentView.addSubviews(closeButton,
                                titleLabel,
                                descriptionLabel,
                                titleTextField,
                                searchButton)
    }
    
    private func setLayout() {
        contentView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(UIScreen.main.bounds.height - 81)
        }
        
        closeButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(20)
            $0.size.equalTo(25)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(closeButton.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(20)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.equalToSuperview().inset(20)
        }
        
        titleTextField.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(33)
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
