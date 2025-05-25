//
//  UserPageGenrePreferencesView.swift
//  WSSiOS
//
//  Created by 신지원 on 11/16/24.
//

import UIKit

import SnapKit
import Then

final class UserPageGenrePreferencesView: UIView {
    
    //MARK: - Components
    
    private let titleLabel = UILabel()
    let userGenrePreferencesView = UserGenrePreferencesView()
    
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
    }
    
    private func setHierarchy() {
        self.addSubviews(titleLabel,
                         userGenrePreferencesView)
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(30)
            $0.leading.equalToSuperview().inset(20)
        }
        
        userGenrePreferencesView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(15)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
    }
}
