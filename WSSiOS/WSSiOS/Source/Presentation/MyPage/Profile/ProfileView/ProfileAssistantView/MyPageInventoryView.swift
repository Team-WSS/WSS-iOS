//
//  MyPageInventoryView.swift
//  WSSiOS
//
//  Created by 신지원 on 11/16/24.
//

import UIKit

import SnapKit
import Then

final class MyPageInventoryView: UIView {
    
    //MARK: - Components
    
    private let titleLabel = UILabel()
    let arrowButton = UIButton()
    private let inventoryView = UIView()
    private let stackView = UIStackView()
    
    private let interestCountLabel = UILabel()
    private let interestLabel = UILabel()
    
    private let watchingCountLabel = UILabel()
    private let watchingLabel = UILabel()
    
    private let watchedCountLabel = UILabel()
    private let watchedLabel = UILabel()
    
    private let quitCountLabel = UILabel()
    private let quitLabel = UILabel()
    
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
        self.backgroundColor = .wssWhite
        
        titleLabel.do {
            $0.applyWSSFont(.title1, with: StringLiterals.MyPage.Profile.inventoryTitle)
            $0.textColor = .wssBlack
        }
        
        arrowButton.do {
            $0.setImage(.icRight.withRenderingMode(.alwaysOriginal).withTintColor(.wssGray200), for: .normal)
            $0.isUserInteractionEnabled = true
        }
        
        inventoryView.do {
            $0.backgroundColor = .wssGray50
            $0.layer.cornerRadius = 14
        }
        
        stackView.do {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.spacing = 2
        }
    }
    
    private func createVerticalStack(countLabel: UILabel, textLabel: UILabel, text: String) -> UIStackView {
        countLabel.do {
            $0.applyWSSFont(.title2, with: "0")
            $0.textAlignment = .center
        }
        
        textLabel.do {
            $0.applyWSSFont(.body5, with: text)
            $0.textColor = .wssGray200
            $0.textAlignment = .center
        }
        
        let verticalStack = UIStackView(arrangedSubviews: [countLabel, textLabel]).then {
            $0.axis = .vertical
            $0.alignment = .center
            $0.spacing = 2
        }
        
        return verticalStack
    }
    
    private func setHierarchy() {
        self.addSubviews(titleLabel,
                         arrowButton,
                         inventoryView)
        inventoryView.addSubview(stackView)
        
        let interestStack = createVerticalStack(countLabel: interestCountLabel, textLabel: interestLabel, text: "관심")
        let watchingStack = createVerticalStack(countLabel: watchingCountLabel, textLabel: watchingLabel, text: "보는중")
        let watchedStack = createVerticalStack(countLabel: watchedCountLabel, textLabel: watchedLabel, text: "봤어요")
        let quitStack = createVerticalStack(countLabel: quitCountLabel, textLabel: quitLabel, text: "하차")
        
        stackView.addArrangedSubviews(interestStack,
                                      watchingStack,
                                      watchedStack,
                                      quitStack)
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(25.5)
            $0.leading.equalToSuperview().inset(20)
        }
        
        arrowButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(20)
            $0.size.equalTo(44)
        }
        
        inventoryView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(9.5)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(70)
            $0.bottom.equalToSuperview().inset(30)
        }
        
        stackView.snp.makeConstraints {
            $0.height.equalTo(38.5)
            $0.leading.trailing.centerY.equalToSuperview()
        }
    }
    
    //MARK: - Data
    
    func bindData(data: UserNovelStatus) {
        interestCountLabel.applyWSSFont(.title2, with: String(describing: data.interestNovelCount))
        watchedCountLabel.applyWSSFont(.title2, with: String(describing: data.watchedNovelCount))
        watchingCountLabel.applyWSSFont(.title2, with: String(describing: data.watchingNovelCount))
        quitCountLabel.applyWSSFont(.title2, with: String(describing: data.quitNovelCount))
    }
}



