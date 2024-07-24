//
//  MyPageDeleteIDWarningView.swift
//  WSSiOS
//
//  Created by 신지원 on 7/24/24.
//

import UIKit

import SnapKit
import Then

final class MyPageDeleteIDWarningView: UIView {
    
    //MARK: - Components
    
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    lazy var completeButton = WSSMainButton(title: StringLiterals.MyPage.DeleteIDWarning.buttonTitle)
    
    private let interestView = MyPageDeleteIDRecordView()
    private let watchingView = MyPageDeleteIDRecordView()
    private let watchedView = MyPageDeleteIDRecordView()
    private let quitView = MyPageDeleteIDRecordView()
    
    //In NavigationBar
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
        
        titleLabel.do {
            $0.applyWSSFont(.headline1, with: StringLiterals.MyPage.DeleteIDWarning.title)
            $0.textColor = .wssBlack
        }
        
        descriptionLabel.do {
            $0.applyWSSFont(.body2, with: StringLiterals.MyPage.DeleteIDWarning.description)
            $0.textColor = .Gray200
        }
        
        backButton.do {
            $0.setImage(.icNavigateLeft.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(titleLabel,
                         descriptionLabel,
                         interestView,
                         watchingView,
                         watchedView,
                         quitView,
                         completeButton)
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(45)
            $0.leading.equalToSuperview().inset(20)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().inset(20)
        }
        
        interestView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(60)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalTo(self.snp.centerX).offset(-3)
        }
        
        watchingView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(60)
            $0.trailing.equalToSuperview().inset(20)
            $0.leading.equalTo(self.snp.centerX).offset(3)
        }
        
        watchedView.snp.makeConstraints {
            $0.top.equalTo(watchingView.snp.bottom).offset(3)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalTo(self.snp.centerX).offset(-3)
        }
        
        quitView.snp.makeConstraints {
            $0.top.equalTo(interestView.snp.bottom).offset(3)
            $0.trailing.equalToSuperview().inset(20)
            $0.leading.equalTo(self.snp.centerX).offset(3)
        }
        
        completeButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(10)
        }
        
        backButton.do {
            $0.setImage(.icNavigateLeft.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    
    //MARK: - Data
    
    func bindData(count: UserNovelStatusResult) {
        interestView.bindData(icon: .interest, status: StringLiterals.MyPage.DeleteIDWarning.interest, count: String(describing: count.interestNovelCount))
        watchingView.bindData(icon: .watching, status: StringLiterals.MyPage.DeleteIDWarning.watching, count: String(describing: count.watchingNovelCount))
        watchedView.bindData(icon: .watched, status: StringLiterals.MyPage.DeleteIDWarning.watched, count: String(describing: count.watchedNovelCount))
        quitView.bindData(icon: .quit, status: StringLiterals.MyPage.DeleteIDWarning.quit, count: String(describing: count.quitNovelCount))
    }
}
