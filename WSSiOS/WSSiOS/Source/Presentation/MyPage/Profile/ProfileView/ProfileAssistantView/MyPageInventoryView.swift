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
    
    //터치영역
    let inventoryView = UIView()
    let inventoryStackView = UIStackView()
    
    private let titleLabel = UILabel()
    private let arrowView = UIView()
    private let arrowImageView = UIImageView()
    private let inventoryDetailView = UIView()
    
    private var interestStackView = UIStackView()
    private let interestCountLabel = UILabel()
    private let interestLabel = UILabel()
    
    private var watchingStackView = UIStackView()
    private let watchingCountLabel = UILabel()
    private let watchingLabel = UILabel()
    
    private var watchedStackView = UIStackView()
    private let watchedCountLabel = UILabel()
    private let watchedLabel = UILabel()
    
    private var quitStackView = UIStackView()
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
        
        inventoryDetailView.do {
            $0.backgroundColor = .wssGray50
            $0.layer.cornerRadius = 14
        }
        
        inventoryStackView.do {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.spacing = 2
        }
        
        let statusList = StringLiterals.ReviewerStatus.allCases.map { $0.rawValue }
        interestStackView = createVerticalStack(tag: 0, countLabel: interestCountLabel, textLabel: interestLabel, text: statusList[0],
                                                addLine: true)
        watchingStackView = createVerticalStack(tag: 1, countLabel: watchingCountLabel, textLabel: watchingLabel, text: statusList[1])
        watchedStackView = createVerticalStack(tag: 2, countLabel: watchedCountLabel, textLabel: watchedLabel, text: statusList[2])
        quitStackView = createVerticalStack(tag: 3, countLabel: quitCountLabel, textLabel: quitLabel, text: statusList[3])
    }
    
    private func createVerticalStack(tag: Int, countLabel: UILabel, textLabel: UILabel, text: String, addLine: Bool = false) -> UIStackView {
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
            $0.tag = tag
        }
        
        if addLine {
            let dividerView = UIView().then {
                $0.backgroundColor = .wssGray70
            }
            
            verticalStack.addSubview(dividerView)
            
            dividerView.snp.makeConstraints {
                $0.centerY.trailing.equalToSuperview()
                $0.height.equalTo(40)
                $0.width.equalTo(1)
            }
        }
        
        return verticalStack
    }
    
    private func setHierarchy() {
        self.addSubview(inventoryView)
        inventoryView.addSubviews(titleLabel,
                                  arrowView,
                                  inventoryDetailView)
        inventoryDetailView.addSubview(inventoryStackView)
        arrowView.addSubview(arrowImageView)
        
        inventoryStackView.addArrangedSubviews(interestStackView,
                                      watchingStackView,
                                      watchedStackView,
                                      quitStackView)
    }
    
    private func setLayout() {
        inventoryView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(30)
            
            arrowView.snp.makeConstraints {
                $0.top.trailing.equalToSuperview()
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
            
            inventoryDetailView.snp.makeConstraints {
                $0.top.equalTo(arrowView.snp.bottom)
                $0.leading.trailing.bottom.equalToSuperview()
                $0.height.equalTo(70)
                
                inventoryStackView.snp.makeConstraints {
                    $0.height.equalTo(38.5)
                    $0.leading.trailing.centerY.equalToSuperview()
                }
            }
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



