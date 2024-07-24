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
    
    private let interestView = MyPageDeleteIDRecordView()
    private let watchingView = MyPageDeleteIDRecordView()
    private let watchedView = MyPageDeleteIDRecordView()
    private let quitView = MyPageDeleteIDRecordView()
    
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
        //
    }
    
    private func setHierarchy() {
        self.addSubviews(interestView,
                         watchingView,
                         watchedView,
                         quitView)
    }
    
    private func setLayout() {

        interestView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(100)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalTo(self.snp.centerX).offset(-3)
        }
        
        watchingView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(100)
            $0.trailing.equalToSuperview().inset(20)
            $0.leading.equalTo(self.snp.centerX).offset(3)
        }
        
        watchedView.snp.makeConstraints {
            $0.top.equalTo(interestView.snp.bottom).offset(3)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalTo(self.snp.centerX).offset(-3)
        }
        
        quitView.snp.makeConstraints {
            $0.top.equalTo(interestView.snp.bottom).offset(3)
            $0.trailing.equalToSuperview().inset(20)
            $0.leading.equalTo(self.snp.centerX).offset(3)
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
