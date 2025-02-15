//
//  ServiceTermAgreementView.swift
//  WSSiOS
//
//  Created by YunhakLee on 2/11/25.
//

import UIKit

import SnapKit
import Then


final class ServiceTermAgreementView: UIView {
    
    //MARK: - Components
    
    private let backgroundView = UIView()
    private let contentView = UIStackView()
    
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    let allAgreeButton = UIButton()
    private let allAgreeButtonLabel = UILabel()
    private let allAgreeButtonImageView = UIImageView()
    
    let serviceTermRowViews: [ServiceTermRowView] = ServiceTerm.allCases.map { ServiceTermRowView($0)}
    
    let bottomButton = UIButton()
    private let bottomButtonLabel = UILabel()
    
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
    
    //MARK: - UI
    
    private func setUI() {
        backgroundView.do {
            $0.backgroundColor = .wssWhite
            $0.layer.cornerRadius = 12
            $0.layer.maskedCorners = [.layerMinXMinYCorner,
                                      .layerMaxXMinYCorner]
        }
        
        contentView.do {
            $0.axis = .vertical
            $0.alignment = .fill
        }
        
        titleLabel.do {
            $0.applyWSSFont(.headline1, with: StringLiterals.ServiceTermAgreement.title)
            $0.textColor = .wssBlack
        }
        
        descriptionLabel.do {
            $0.applyWSSFont(.body2, with: StringLiterals.ServiceTermAgreement.description)
            $0.textColor = .wssGray200
        }
        
        allAgreeButton.do {
            $0.backgroundColor = .wssPrimary20
            $0.layer.cornerRadius = 14
            
            allAgreeButtonLabel.do {
                $0.applyWSSFont(.title2, with: StringLiterals.ServiceTermAgreement.agreeAllButton)
                $0.textColor = .wssPrimary100
                $0.isUserInteractionEnabled = false
            }
            
            allAgreeButtonImageView.do {
                $0.image = .icSelectNovelDefault2
                $0.isUserInteractionEnabled = false
            }
        }
        
        bottomButton.do {
            $0.backgroundColor = .wssGray70
            $0.layer.cornerRadius = 14
            $0.isEnabled = false
            
            bottomButtonLabel.do {
                $0.applyWSSFont(.title1,
                                with: APIConstants.isRegister ? StringLiterals.ServiceTermAgreement.bottomButtonComplete
                                                              : StringLiterals.ServiceTermAgreement.bottomButtonNext)
                $0.textColor = .wssWhite
                $0.isUserInteractionEnabled = false
            }
        }
    }
    
    private func setHierarchy() {
        self.addSubview(backgroundView)
        backgroundView.addSubviews(contentView,
                                   bottomButton)
        contentView.addArrangedSubviews(titleLabel,
                                        descriptionLabel,
                                        allAgreeButton)
        serviceTermRowViews.forEach { contentView.addArrangedSubview($0) }
        allAgreeButton.addSubviews(allAgreeButtonLabel,
                                   allAgreeButtonImageView)
        bottomButton.addSubview(bottomButtonLabel)
    }
    
    private func setLayout() {
        backgroundView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            if UIScreen.isSE {
                $0.height.equalTo(635)
            } else {
                $0.height.equalTo(670)
            }
        }
        
        contentView.do {
            $0.snp.makeConstraints {
                $0.top.equalToSuperview().inset(48)
                $0.horizontalEdges.equalToSuperview().inset(20)
            }
            
            $0.setCustomSpacing(8, after: titleLabel)
            $0.setCustomSpacing(64, after: descriptionLabel)
            $0.setCustomSpacing(32, after: allAgreeButton)
        }
        
        allAgreeButton.snp.makeConstraints {
            $0.height.equalTo(56)
            
            allAgreeButtonLabel.snp.makeConstraints {
                $0.leading.equalToSuperview().inset(16)
                $0.centerY.equalToSuperview()
            }
            
            allAgreeButtonImageView.snp.makeConstraints {
                $0.trailing.equalToSuperview().inset(16)
                $0.centerY.equalToSuperview()
                $0.size.equalTo(24)
            }
        }
        
        bottomButton.snp.makeConstraints {
            $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-10)
            $0.height.equalTo(53)
            $0.horizontalEdges.equalToSuperview().inset(16)
            
            bottomButtonLabel.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
        }
    }
    
    //MARK: - Custom Method
    
    func updateAllAgreeButton(isAllAgreed: Bool) {
        allAgreeButtonImageView.image = isAllAgreed ? .icSelectNovelSelected : .icSelectNovelDefault2
    }
    
    func updateBottomButton(isEnabled: Bool) {
        bottomButton.do {
            $0.backgroundColor = isEnabled ? .wssPrimary100 : .wssGray70
            $0.layer.cornerRadius = 14
            $0.isEnabled = isEnabled
        }
    }
}
