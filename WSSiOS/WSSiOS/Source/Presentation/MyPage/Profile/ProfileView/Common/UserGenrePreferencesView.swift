//
//  UserGenrePreferencesView.swift
//  WSSiOS
//
//  Created by 신지원 on 5/23/25.
//

import UIKit

import SnapKit
import Then

final class UserGenrePreferencesView: UIView {
    
    //MARK: - Components
    
    var genreStackView = UIStackView()
    
    private let topView = UIView()
    private let firstTopGenreView = UserPageGenrePreferencesTopView()
    private let secondTopGenreView = UserPageGenrePreferencesTopView()
    private let thirdTopGenreView = UserPageGenrePreferencesTopView()
    
    let userPageGenreOpenButton = UIButton()
    let userPageOtherGenreView = UserPageGenrePreferencesOtherView()
    let userPageGenreCloseButton = UIButton()
    
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
        
        genreStackView.do {
            $0.axis = .vertical
            $0.spacing = 0
            $0.alignment = .fill
            $0.distribution = .fill
        }
        
        userPageGenreOpenButton.do {
            $0.backgroundColor = .wssWhite
            $0.setImage(.icChevronDown, for: .normal)
        }
        
        userPageOtherGenreView.isHidden = true
        
        userPageGenreCloseButton.do {
            $0.backgroundColor = .wssWhite
            $0.setImage(.icChevronUp, for: .normal)
        }
    }
    
    private func setHierarchy() {
        self.addSubview(genreStackView)
        genreStackView.addArrangedSubviews(topView,
                                           userPageGenreOpenButton,
                                           userPageOtherGenreView,
                                           userPageGenreCloseButton)
        topView.addSubviews(firstTopGenreView,
                            secondTopGenreView,
                            thirdTopGenreView)
    }
    
    private func setLayout() {
        genreStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(224.5)
        }
        
        topView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(95)
        }
        
        firstTopGenreView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalTo(secondTopGenreView.snp.leading)
            $0.height.equalTo(95)
            $0.width.equalTo((UIScreen.main.bounds.width-42)/3)
        }
        
        secondTopGenreView.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
            $0.height.equalTo(95)
            $0.width.equalTo((UIScreen.main.bounds.width-42)/3)
        }
        
        thirdTopGenreView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(secondTopGenreView.snp.trailing)
            $0.height.equalTo(95)
            $0.width.equalTo((UIScreen.main.bounds.width-42)/3)
        }
        
        userPageGenreOpenButton.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        userPageOtherGenreView.snp.makeConstraints {
            $0.height.equalTo(0)
        }
        
        userPageGenreOpenButton.snp.makeConstraints {
            $0.height.equalTo(0)
        }
    }
    
    //MARK: - Custom Method
    
    func updateGenreViewHeight(isExpanded: Bool) {
        genreStackView.snp.updateConstraints {
            $0.height.equalTo(isExpanded ? 429 : 145)
        }
    }
    
    func updateView(showOtherGenreView: Bool) {
        userPageGenreOpenButton.isHidden = showOtherGenreView
        userPageOtherGenreView.isHidden = !showOtherGenreView
        userPageGenreCloseButton.isHidden = !showOtherGenreView
        
        genreStackView.setCustomSpacing(showOtherGenreView ? 32 : 0, after: topView)
        genreStackView.setCustomSpacing(showOtherGenreView ? 20 : 0, after: userPageOtherGenreView)
        
        userPageGenreOpenButton.snp.updateConstraints {
            $0.height.equalTo(showOtherGenreView ? 0 : 44)
        }
        
        userPageOtherGenreView.snp.updateConstraints {
            $0.height.equalTo(showOtherGenreView ? 250 : 0)
        }
        
        userPageGenreCloseButton.snp.updateConstraints {
            $0.height.equalTo(showOtherGenreView ? 44 : 0)
        }
    }
    
    //MARK: - Data
    
    func bindData(data: UserGenrePreferencesListEntity) {
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
