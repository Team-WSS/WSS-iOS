//
//  MyPageGenrePreferencesView.swift
//  WSSiOS
//
//  Created by 신지원 on 11/16/24.
//

import UIKit

import SnapKit
import Then

final class MyPageGenrePreferencesView: UIView {

    //MARK: - Components
    
    private let titleLabel = UILabel()
    
    private let firstTopGenreView = MyPageGenrePreferencesTopView()
    private let secondTopGenreView = MyPageGenrePreferencesTopView()
    private let thirdTopGenreView = MyPageGenrePreferencesTopView()
    
    let myPageGenreOpenButton = UIButton()
    
    private let otherGenreView = UIView()
    
    
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
            $0.applyWSSFont(.title1, with: StringLiterals.MyPage.Profile.genrePreferenceTitle)
            $0.textColor = .wssBlack
        }
        
        myPageGenreOpenButton.do {
            $0.backgroundColor = .wssWhite
            $0.setImage(.icDownArrow, for: .normal)
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(titleLabel,
                         firstTopGenreView,
                         secondTopGenreView,
                         thirdTopGenreView,
                         myPageGenreOpenButton)
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(30)
            $0.leading.equalToSuperview().inset(20)
        }
        
        firstTopGenreView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(15)
            $0.trailing.equalTo(secondTopGenreView.snp.leading)
            $0.height.equalTo(95)
            $0.width.equalTo((UIScreen.main.bounds.width-42)/3)
        }
        
        secondTopGenreView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(15)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(95)
            $0.width.equalTo((UIScreen.main.bounds.width-42)/3)
        }
        
        thirdTopGenreView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(15)
            $0.leading.equalTo(secondTopGenreView.snp.trailing)
            $0.height.equalTo(95)
            $0.width.equalTo((UIScreen.main.bounds.width-42)/3)
        }
        
        myPageGenreOpenButton.snp.makeConstraints {
            $0.top.equalTo(thirdTopGenreView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
            $0.bottom.equalToSuperview()
        }
    }
    
    //MARK: - Data
    
    func bindData(data: UserGenrePreferences) {
        if data.genrePreferences.indices.contains(0) {
            firstTopGenreView.bindData(data: data.genrePreferences[0])
        }

        if data.genrePreferences.indices.contains(1) {
            secondTopGenreView.bindData(data: data.genrePreferences[1])
        }

        if data.genrePreferences.indices.contains(2) {
            thirdTopGenreView.bindData(data: data.genrePreferences[2])
        }
    }
}



