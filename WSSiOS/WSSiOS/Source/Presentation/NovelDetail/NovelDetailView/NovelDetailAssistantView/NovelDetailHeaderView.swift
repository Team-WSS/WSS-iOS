//
//  NovelDetailHeaderView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 1/11/24.
//

import UIKit

import SnapKit
import Then

final class NovelDetailHeaderView: UIView {

    // MARK: - UI Components
    
    private let backgroundImageView = UIImageView()
    private let genreImageView = UIImageView()
    private let novelTitleLabel = UILabel()
    private let novelAuthorLabel = UILabel()
    private let novelCoverImageView = UIImageView()
    
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

    // MARK: - set UI
    
    private func setUI() {
        backgroundImageView.do {
            $0.contentMode = .scaleAspectFit
            $0.backgroundColor = .Gray300
        }
        
        genreImageView.do {
            $0.image = ImageLiterals.icon.icGenre.bl
            $0.contentMode = .scaleAspectFit
        }
        
        novelTitleLabel.do {
            $0.text = "여자친구를 삼으려고 학생회장을 꼭 닮은 여자아이를 연성했다가 내가 하인이 됐습니다"
            $0.font = .HeadLine1
            $0.textColor = .White
            $0.numberOfLines = 3
            $0.lineBreakMode = .byTruncatingTail
            $0.lineBreakStrategy = .hangulWordPriority
        }
        
        novelAuthorLabel.do {
            $0.text = "Satoru Yamaguchi"
            $0.font = .Body2
            $0.textColor = .Gray200
            $0.lineBreakMode = .byTruncatingTail
        }
        
        novelCoverImageView.do {
            $0.image = UIImage(named: "sample1")
            $0.layer.cornerRadius = 6
        }
    }
    
    // MARK: - set Hierachy
    
    private func setHierachy() {
        self.addSubviews(backgroundImageView,
                         genreImageView,
                         novelTitleLabel,
                         novelAuthorLabel,
                         novelCoverImageView)
    }
    
    // MARK: - set Layout
    
    private func setLayout() {
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(302)
        }
        
        genreImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(120)
            $0.leading.equalToSuperview().inset(20)
            $0.size.equalTo(40)
        }
        
        novelCoverImageView.snp.makeConstraints {
            $0.top.equalTo(genreImageView.snp.bottom).offset(10)
            $0.trailing.equalToSuperview().inset(24)
            $0.width.equalTo(68)
            $0.height.equalTo(93)
        }
        
        novelTitleLabel.snp.makeConstraints {
            $0.top.equalTo(genreImageView.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalTo(novelCoverImageView.snp.leading).offset(-18)
        }
        
        novelAuthorLabel.snp.makeConstraints {
            $0.top.equalTo(novelTitleLabel.snp.bottom).offset(6)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalTo(novelCoverImageView.snp.leading).offset(-18)
        }
    }
}
