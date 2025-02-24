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
    
    private let inventoryView = UIView()
    
    //터치영역
    let inventoryTitleView = UIView()
    let inventoryStackView = UIStackView()
    
    private let titleLabel = UILabel()
    private let arrowView = UIView()
    private let arrowImageView = UIImageView()
    
    var readStatusButtons = [UIButton()]
    
    private let interestCountLabel = UILabel()
    private let watchingCountLabel = UILabel()
    private let watchedCountLabel = UILabel()
    private let quitCountLabel = UILabel()
    
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
        
        inventoryView.do {
            $0.backgroundColor = .wssWhite
        }
        
        titleLabel.do {
            $0.applyWSSFont(.title1, with: StringLiterals.MyPage.Profile.inventoryTitle)
            $0.textColor = .wssBlack
        }
        
        arrowImageView.do {
            $0.image = .icNavigateRight.withRenderingMode(.alwaysOriginal).withTintColor(.wssGray200)
            $0.contentMode = .center
        }
        
        inventoryStackView.do {
            $0.backgroundColor = .wssGray50
            $0.layer.cornerRadius = 14
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.spacing = 2
        }
        
        let countLabels: [UILabel] = [
            interestCountLabel,
            watchingCountLabel,
            watchedCountLabel,
            quitCountLabel
        ]
        
        readStatusButtons = StringLiterals.ReviewerStatus.allCases.enumerated().map { index, status in
            createInventorySectionView (
                countLabel: countLabels[index],
                text: status.rawValue,
                addLine: index == 0)
        }
    }
    
    private func setHierarchy() {
        self.addSubview(inventoryView)
        inventoryView.addSubviews(inventoryTitleView,
                                  inventoryStackView)
        inventoryTitleView.addSubviews(titleLabel,
                                       arrowView)
        arrowView.addSubview(arrowImageView)
        
        readStatusButtons.forEach {
            inventoryStackView.addArrangedSubviews($0)
        }
    }
    
    private func setLayout() {
        inventoryView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(30)
            
            inventoryTitleView.snp.makeConstraints {
                $0.top.width.equalToSuperview()
                
                arrowView.snp.makeConstraints {
                    $0.top.trailing.bottom.equalToSuperview()
                    $0.size.equalTo(44)
                    
                    arrowImageView.snp.makeConstraints {
                        $0.center.equalToSuperview()
                        $0.size.equalTo(24)
                    }
                }
                
                titleLabel.snp.makeConstraints {
                    $0.leading.equalToSuperview()
                    $0.centerY.equalTo(arrowView.snp.centerY)
                }
            }
            
            inventoryStackView.snp.makeConstraints {
                $0.top.equalTo(inventoryTitleView.snp.bottom)
                $0.leading.trailing.bottom.equalToSuperview()
                $0.height.equalTo(70)
            }
        }
    }
    
    //MARK: - Custom Method
    
    private func createInventorySectionView(countLabel: UILabel, text: String, addLine: Bool = false) -> UIButton {
        let statusButton = UIButton()
        let textLabel = UILabel()
        
        countLabel.do {
            $0.applyWSSFont(.title2, with: "0")
            $0.textAlignment = .center
        }
        
        textLabel.do {
            $0.applyWSSFont(.body5, with: text)
            $0.textColor = .wssGray200
            $0.textAlignment = .center
        }
        
        statusButton.addSubviews(countLabel,
                                 textLabel)
        
        countLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(13.5)
            $0.centerX.equalToSuperview()
        }
        
        textLabel.snp.makeConstraints {
            $0.top.equalTo(countLabel.snp.bottom).offset(2)
            $0.centerX.equalToSuperview()
        }
        
        if addLine {
            let dividerView = UIView().then {
                $0.backgroundColor = .wssGray70
            }
            
            statusButton.addSubview(dividerView)
            
            dividerView.snp.makeConstraints {
                $0.centerY.trailing.equalToSuperview()
                $0.height.equalTo(40)
                $0.width.equalTo(1)
            }
        }
        
        return statusButton
    }
    
    //MARK: - Data
    
    func bindData(data: UserNovelStatus) {
        interestCountLabel.applyWSSFont(.title2, with: String(describing: data.interestNovelCount))
        watchedCountLabel.applyWSSFont(.title2, with: String(describing: data.watchedNovelCount))
        watchingCountLabel.applyWSSFont(.title2, with: String(describing: data.watchingNovelCount))
        quitCountLabel.applyWSSFont(.title2, with: String(describing: data.quitNovelCount))
    }
}
