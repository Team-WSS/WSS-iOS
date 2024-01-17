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
    
    //MARK: - UI Components
    
    var myPageBadgeImageView = UIImageView()
    var myPageNameLabel = UILabel()
    var myPagePhraseLabel = UILabel()
    var myPageAvartarImageView = UIImageView()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierachy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - set UI
    
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
            $0.contentMode = .scaleToFill
        }
    }
    
    //MARK: - set Hierachy
    
    private func setHierachy() {
        self.addSubviews(myPageBadgeImageView,
                         myPageNameLabel,
                         myPagePhraseLabel,
                         myPageAvartarImageView)
    }
    
    //MARK: - set Layout
    
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
}
