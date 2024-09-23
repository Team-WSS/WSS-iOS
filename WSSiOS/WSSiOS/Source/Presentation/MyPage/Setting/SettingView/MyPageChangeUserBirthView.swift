//
//  MyPageChangeUserBirthView.swift
//  WSSiOS
//
//  Created by 신지원 on 9/23/24.
//

import UIKit

import SnapKit
import Then

final class MyPageChangeUserBirthView: UIView {
    
    //MARK: - Components
    
    let contentView = UIView()
    private let titleLabel = UILabel()
    let cancelButton = UIButton()
    let completeButton = WSSMainButton(title: "완료")
    
    private let tableView = UITableView()
    
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
        contentView.do {
            $0.backgroundColor = .wssWhite
            $0.layer.cornerRadius = 12
            $0.layer.maskedCorners = [.layerMinXMinYCorner,
                                      .layerMaxXMinYCorner]
        }
        
        titleLabel.do {
            $0.textColor = .wssBlack
            $0.applyWSSFont(.title1, with: "출생연도")
        }
        
        cancelButton.do {
            $0.setImage(.icCancel.withRenderingMode(.alwaysOriginal).withTintColor(.wssGray300), for: .normal)
        }
    }
    
    private func setHierarchy() {
        self.addSubview(contentView)
        contentView.addSubviews(tableView,
                                titleLabel,
                                cancelButton,
                                completeButton)
    }
    
    private func setLayout() {
        contentView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(UIScreen.main.bounds.height - 81)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(15)
            $0.leading.equalToSuperview().inset(20)
        }
        
        cancelButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview()
            $0.size.equalTo(65)
        }
    }
}
