//
//  AlertButtonView.swift
//  WSSiOS
//
//  Created by 신지원 on 7/14/24.
//

import UIKit

import SnapKit
import Then

final class WSSAlertButtonView: UIView {
    
    // MARK: - UI Components
    
    private let stackView = UIStackView()
    private let alertImageView = UIImage(resource: .icAlertWarningCircle)
    var alertTitle = UILabel()
    var alertContentLabel = UILabel()
    var cancelButton = UIButton()
    var actionButton = UIButton()
    
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
    
    // MARK: - Custom Method
    
    private func setUI() {
        stackView.do {
            $0.axis = .vertical
            $0.alignment = .center
        }

        alertTitle.do {
            $0.textColor = .wssBlack
            $0.applyWSSFont(.title1, with: "하하하")
        }
        
        alertContentLabel.do {
            $0.textColor = .Gray300
            $0.applyWSSFont(.body2, with: "해당 글이 커뮤니티 가이드를\n위반했는지 검토할게요")
        }
//                                      cancelButton,
//                                      actionButton
    }
    
    private func setHierarchy() {
        self.addSubview(stackView)
        stackView.addArrangedSubviews(alertImageView,
                                      alertTitle,
                                      alertContentLabel,
                                      cancelButton,
                                      actionButton)
    }
    
    private func setLayout() {
        stackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(24)
            $0.leading.trailing.equalToSuperview().inset(21)
        }
        
        alertImageView.snp.makeConstraints {
            $0.size.equalTo(60)
        }
    }
}

