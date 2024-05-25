//
//  HomeUnregisterView.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/25/24.
//

import UIKit

import SnapKit
import Then

enum UnregisterStatus {
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
    
    private func setUI() {
        self.do {
            $0.backgroundColor = .clear
            $0.layer.cornerRadius = 14
            $0.layer.borderColor = UIColor.wssGray70.cgColor
            $0.layer.borderWidth = 1
        }
    }
    
    private func setHierarchy() {
        
    }
    
    private func setLayout() {
        
    }
}

