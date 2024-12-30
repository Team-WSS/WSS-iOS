//
//  MyPageDeleteIDView.swift
//  WSSiOS
//
//  Created by 신지원 on 7/24/24.
//

import UIKit

import SnapKit
import Then

final class MyPageDeleteIDView: UIView {
    
    //MARK: - Components
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    let reasonView = MyPageDeleteIDReasonView()
    let checkView = MyPageDeleteIDCheckView()
    lazy var agreeDeleteIDButton = UIButton()
    private let agreeDeleteIDLabel = UILabel()
    
    //In NavigationBar
    lazy var completeButton = UIButton()
    lazy var backButton = UIButton()
    
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
        
        scrollView.do {
            $0.showsVerticalScrollIndicator = false
            $0.delaysContentTouches = false
        }
        
        agreeDeleteIDButton.do {
            $0.setImage(.icSelectNovelDefault, for: .normal)
        }
        
        agreeDeleteIDLabel.do {
            $0.applyWSSFont(.body2, with: StringLiterals.MyPage.DeleteID.agreeTitle)
            $0.textColor = .wssGray300
        }
        
        completeButton.do {
            $0.backgroundColor = .wssGray70
            $0.layer.cornerRadius = 14
            $0.setTitle(StringLiterals.MyPage.DeleteIDWarning.buttonTitle, for: .normal)
            $0.setTitleColor(.wssWhite, for: .normal)
            $0.titleLabel?.font = .Title1
            $0.isEnabled = false
        }
        
        backButton.do {
            $0.setImage(.icNavigateLeft.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    
    private func setHierarchy() {
        self.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(reasonView,
                                checkView,
                                agreeDeleteIDButton,
                                agreeDeleteIDLabel,
                                completeButton)
    }
    
    private func setLayout() {
        scrollView.snp.makeConstraints {
            if UIScreen.isSE {
                $0.edges.equalTo(safeAreaLayoutGuide.snp.edges)
            } else {
                $0.edges.equalToSuperview()
            }
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        reasonView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(45)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        checkView.snp.makeConstraints {
            $0.top.equalTo(reasonView.snp.bottom).offset(60)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        agreeDeleteIDButton.snp.makeConstraints {
            $0.top.equalTo(checkView.snp.bottom).offset(34)
            $0.leading.equalToSuperview().inset(16)
            $0.size.equalTo(24)
        }
        
        agreeDeleteIDLabel.snp.makeConstraints {
            $0.centerY.equalTo(agreeDeleteIDButton.snp.centerY)
            $0.leading.equalTo(agreeDeleteIDButton.snp.trailing).offset(10)
        }
        
        completeButton.snp.makeConstraints {
            $0.top.equalTo(agreeDeleteIDButton.snp.bottom).offset(22)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(53)
            $0.bottom.equalToSuperview().inset(10)
        }
        
        backButton.snp.makeConstraints {
            $0.size.equalTo(24)
        }
    }
}

extension MyPageDeleteIDView {
    
    //MARK: - Custom Method
    
    func agreeDeleteIDButtonIsSelected(isSelected: Bool) {
        agreeDeleteIDButton.setImage( isSelected ? .icSelectNovelSelected : .icSelectNovelDefault, for: .normal)
    }
    
    func completeButtonIsEnabled(isEnabled: Bool) {
        completeButton.backgroundColor = isEnabled ? .wssPrimary100 : .wssGray70
        completeButton.isEnabled = isEnabled
    }
}


