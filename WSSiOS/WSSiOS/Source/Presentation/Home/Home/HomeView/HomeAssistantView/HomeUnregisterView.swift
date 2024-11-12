//
//  HomeUnregisterView.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/25/24.
//

import UIKit

import SnapKit
import Then

enum UnregisterType {
    case interest
    case tasteRecommend
    case interestEmpty
    
    var title: String {
        switch self {
        case .interest:
            return StringLiterals.Home.Unregister.Title.interest
        case .tasteRecommend:
            return StringLiterals.Home.Unregister.Title.recommend
        case .interestEmpty:
            return StringLiterals.Home.Unregister.Title.interestEmpty
        }
    }
    
    var buttonTitle: String? {
        switch self {
        case .interest:
            return StringLiterals.Home.Unregister.ButtonTItle.interest
        case .tasteRecommend:
            return StringLiterals.Home.Unregister.ButtonTItle.recommend
        case .interestEmpty:
            return nil
        }
    }
    
    var buttonColor: UIColor? {
        switch self {
        case .interest:
            return .wssSecondary100
        case .tasteRecommend:
            return .wssPrimary100
        case .interestEmpty:
            return nil
        }
    }
}

final class HomeUnregisterView: UIView {
    
    //MARK: - UI Components
    
    private var titleLabel = UILabel()
    var registerButton = UIButton()
    private let registerButtonLabel = UILabel()
    
    //MARK: - Life Cycle
    
    init(_ unregisterType : UnregisterType) {
        super.init(frame: .zero)
        
        setUI()
        setHierarchy()
        setLayout()
        
        bindData(unregisterType)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        self.do {
            $0.backgroundColor = .clear
            $0.layer.cornerRadius = 14
            $0.layer.borderColor = UIColor.wssGray70.cgColor
            $0.layer.borderWidth = 1
        }
        
        titleLabel.do {
            $0.textColor = .wssGray200
        }
        
        registerButton.do {
            $0.setTitleColor(.wssWhite, for: .normal)
            $0.layer.cornerRadius = 8
        }
        
        registerButtonLabel.do {
            $0.textColor = .wssWhite
            $0.isUserInteractionEnabled = false
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(titleLabel,
                         registerButton)
        registerButton.addSubview(registerButtonLabel)
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(24)
        }
        
        registerButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(14)
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.width.equalTo(138)
            $0.height.equalTo(33)
            $0.bottom.equalToSuperview().inset(20)
            
            registerButtonLabel.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
        }
    }
    
    private func bindData(_ type: UnregisterType) {
        self.titleLabel.do {
            $0.applyWSSFont(.body2, with: type.title)
            $0.numberOfLines = 2
        }
        
        if let buttonTitle = type.buttonTitle, let buttonColor = type.buttonColor {
            self.registerButton.do {
                $0.isHidden = false
                $0.backgroundColor = buttonColor
            }
            self.registerButtonLabel.do {
                $0.applyWSSFont(.title3, with: buttonTitle)
            }
        } else {
            self.registerButton.isHidden = true
        }
        
        self.updateLayoutForUnregisterType(type)
    }
    
    private func updateLayoutForUnregisterType(_ type: UnregisterType) {
        if type.buttonTitle == nil {
            titleLabel.snp.remakeConstraints {
                $0.top.equalToSuperview().inset(20)
                $0.leading.equalToSuperview().inset(24)
                $0.bottom.equalToSuperview().inset(20)
            }
        } else {
            titleLabel.snp.remakeConstraints {
                $0.top.equalToSuperview().inset(20)
                $0.leading.equalToSuperview().inset(24)
            }
            
            registerButton.snp.remakeConstraints {
                $0.top.equalTo(titleLabel.snp.bottom).offset(14)
                $0.leading.equalTo(titleLabel.snp.leading)
                $0.width.equalTo(138)
                $0.height.equalTo(33)
                $0.bottom.equalToSuperview().inset(20)
            }
        }
    }
}
