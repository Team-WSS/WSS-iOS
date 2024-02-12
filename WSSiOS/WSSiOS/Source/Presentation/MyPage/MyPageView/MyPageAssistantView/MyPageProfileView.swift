//
//  myPageProfileView.swift
//  WSSiOS
//
//  Created by 신지원 on 1/10/24.
//

import UIKit

import SnapKit
import Then

final class MyPageProfileView: UIView {
    
    //MARK: - Components
    
    private let myPageBadgeImageView = UIImageView()
    private let myPageNameLabel = UILabel()
    private let myPagePhraseLabel = UILabel()
    private let myPageAvartarImageView = UIImageView()
    
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
        self.backgroundColor = .Gray50
        
        myPageNameLabel.do {
            $0.font = .Title1
            $0.textColor = .Gray300
            $0.textAlignment = .center
        }
        
        myPagePhraseLabel.do {
            $0.font = .Body2
            $0.textColor = .Gray300
            $0.textAlignment = .center
        }
        
        myPageAvartarImageView.do {
            $0.contentMode = .scaleAspectFit
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(myPageBadgeImageView,
                         myPageNameLabel,
                         myPagePhraseLabel,
                         myPageAvartarImageView)
    }

    private func setLayout() {
        myPageBadgeImageView.snp.makeConstraints() {
            $0.top.equalTo(super.safeAreaLayoutGuide).offset(27)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(40)
        }
        
        myPageNameLabel.snp.makeConstraints() {
            $0.top.equalTo(myPageBadgeImageView.snp.bottom).offset(13)
            $0.centerX.equalToSuperview()
        }
        
        myPagePhraseLabel.snp.makeConstraints() {
            $0.top.equalTo(myPageNameLabel.snp.bottom)
            $0.centerX.equalToSuperview()
        }
        
        myPageAvartarImageView.snp.makeConstraints() {
            $0.top.equalTo(myPagePhraseLabel.snp.bottom).offset(23)
            $0.centerX.bottom.equalToSuperview()
            $0.size.equalTo(220)
        }
    }
    
    //MARK: - Data
    
    func bindProfileViewData(_ data: UserResult) {
        myPageNameLabel.text = data.representativeAvatarTag
        myPageBadgeImageView.kfSetImage(url: data.representativeAvatarGenreBadge)
        myPagePhraseLabel.text = data.representativeAvatarLineContent
        myPageAvartarImageView.kfSetImage(url: data.representativeAvatarImg)
    }
}
