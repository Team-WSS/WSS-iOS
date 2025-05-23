//
//  UserPageInventoryView.swift
//  WSSiOS
//
//  Created by 신지원 on 11/16/24.
//

import UIKit

import SnapKit
import Then

final class UserPageInventoryView: UIView {
    
    //MARK: - Components
    
    private let inventoryView = UIView()
    
    //터치영역
    let inventoryTitleView = UIView()
    let userPageLibraryStatusView = UserLibraryStatusView()
    
    private let titleLabel = UILabel()
    private let arrowView = UIView()
    private let arrowImageView = UIImageView()
    
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
    }
    
    private func setHierarchy() {
        self.addSubview(inventoryView)
        inventoryView.addSubviews(inventoryTitleView,
                                  userPageLibraryStatusView)
        inventoryTitleView.addSubviews(titleLabel,
                                       arrowView)
        arrowView.addSubview(arrowImageView)
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
            
            userPageLibraryStatusView.snp.makeConstraints {
                $0.top.equalTo(inventoryTitleView.snp.bottom)
                $0.leading.trailing.bottom.equalToSuperview()
                $0.height.equalTo(70)
            }
        }
    }
}
