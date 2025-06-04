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
    
    private let genreTopThreeView = UIView()
    private let firstTopGenreView = UserGenrePreferencesTopView()
    private let secondTopGenreView = UserGenrePreferencesTopView()
    private let thirdTopGenreView = UserGenrePreferencesTopView()
    
    let userGenreOpenButton = UIButton()
    let userOtherGenreView = UserGenrePreferencesOtherView()
    let userGenreCloseButton = UIButton()
    
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
            $0.alignment = .center
            $0.distribution = .fill
        }
        
        userGenreOpenButton.do {
            $0.backgroundColor = .wssWhite
            $0.setImage(.icChevronDown, for: .normal)
        }
        
        userOtherGenreView.isHidden = true
        
        userGenreCloseButton.do {
            $0.backgroundColor = .wssWhite
            $0.setImage(.icChevronUp, for: .normal)
        }
    }
    
    private func setHierarchy() {
        self.addSubview(genreStackView)
        genreStackView.addArrangedSubviews(genreTopThreeView,
                                           userGenreOpenButton,
                                           userOtherGenreView,
                                           userGenreCloseButton)
        genreTopThreeView.addSubviews(firstTopGenreView,
                            secondTopGenreView,
                            thirdTopGenreView)
    }
    
    private func setLayout() {
        genreStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(145).priority(.required)
        }
    
        genreTopThreeView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(95)
        }
        
        firstTopGenreView.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(1.0 / 3.0)
            $0.height.equalTo(95)
        }
        
        secondTopGenreView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(firstTopGenreView.snp.trailing)
            $0.width.equalToSuperview().multipliedBy(1.0 / 3.0)
            $0.height.equalTo(95)
        }
        
        thirdTopGenreView.snp.makeConstraints {
            $0.top.trailing.equalToSuperview()
            $0.leading.equalTo(secondTopGenreView.snp.trailing)
            $0.height.equalTo(95)
        }
        
        userGenreOpenButton.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        userOtherGenreView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(13)
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
        userGenreOpenButton.isHidden = showOtherGenreView
        userOtherGenreView.isHidden = !showOtherGenreView
        userGenreCloseButton.isHidden = !showOtherGenreView
        
        genreStackView.setCustomSpacing(showOtherGenreView ? 20 : 6, after: genreTopThreeView)
        genreStackView.setCustomSpacing(showOtherGenreView ? 20 : 0, after: userOtherGenreView)
        
        userGenreOpenButton.snp.remakeConstraints {
            $0.height.equalTo(showOtherGenreView ? 0 : 44)
            if !showOtherGenreView {
                $0.horizontalEdges.bottom.equalToSuperview()
            }
        }
        
        userOtherGenreView.snp.updateConstraints {
            $0.height.equalTo(showOtherGenreView ? 240 : 0)
        }
        
        userGenreCloseButton.snp.remakeConstraints {
            $0.height.equalTo(showOtherGenreView ? 44 : 0)
            if showOtherGenreView {
                $0.horizontalEdges.bottom.equalToSuperview()
            }
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
