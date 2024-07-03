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
    
    var title: String {
        switch self {
        case .interest:
            return StringLiterals.Home.Unregister.Title.interest
        case .tasteRecommend:
            return StringLiterals.Home.Unregister.Title.recommend
        }
    }
    
    var buttonTitle: String {
        switch self {
        case .interest:
            return StringLiterals.Home.Unregister.ButtonTItle.interest
        case .tasteRecommend:
            return StringLiterals.Home.Unregister.ButtonTItle.recommend
        }
    }
    
    var buttonColor: UIColor {
        switch self {
        case .interest:
            return .wssSecondary100
        case .tasteRecommend:
            return .wssPrimary100
        }
    }
}

final class HomeUnregisterView: UIView {
    
    //MARK: - UI Components
    
    private var titleLabel = UILabel()
    private var registerButton = UIButton()
    
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
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(titleLabel,
                         registerButton)
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(24)
        }
        
        registerButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(14)
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
    
    private func bindData(_ type: UnregisterType) {
        self.titleLabel.do {
            $0.applyWSSFont(.body2, with: type.title)
            $0.numberOfLines = 2
        }
        
        self.registerButton.do {
            var configuration = UIButton.Configuration.filled()
            configuration.background.cornerRadius = 8
            configuration.contentInsets = NSDirectionalEdgeInsets(top: 9, leading: 21, bottom: 9, trailing: 21)
            configuration.baseBackgroundColor = type.buttonColor
            
            var titleAttr = AttributedString.init(type.buttonTitle)
            titleAttr.kern = -0.6
            titleAttr.font = UIFont.Title3
            configuration.attributedTitle = titleAttr
            $0.configuration = configuration
        }
    }
}

