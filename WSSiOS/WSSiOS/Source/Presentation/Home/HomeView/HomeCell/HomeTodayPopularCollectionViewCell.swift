//
//  HomeTodayPopularCollectionViewCell.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 4/15/24.
//

import UIKit

final class HomeTodayPopularCollectionViewCell: UICollectionViewCell {
    
    //MARK: - UI Components
    
    private let backgroundImageView = UIImageView()
    private let bestTagImageView = UIImageView()
    private let novelTitleLabel = UILabel()
    private let novelImageView = UIImageView()
    
    private let blurBackgroundView = UIView()
    private let userProfileView = UIView()
    private let commentTitleLabel = UILabel()
    private let commaStartedImageView = UIImageView()
    private let commaFinishedImageView = UIImageView()
    private let commentContentLabel = UILabel()
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        backgroundImageView.do {
            $0.image = .imgTodayPopularBackground
            $0.layer.cornerRadius = 14
            $0.clipsToBounds = true
        }
        
        bestTagImageView.do {
            $0.image = .icBest
        }
        
        novelTitleLabel.do {
            $0.font = .Title2
            $0.textColor = .wssBlack
            $0.makeAttribute(with: "상수리 나무 아래라구요오오오오오오오오오오오오오옷")?
                .kerning(kerningPixel: -0.6)
                .lineSpacing(spacingPercentage: 140)
                .applyAttribute()
            $0.numberOfLines = 1
            $0.lineBreakMode = .byTruncatingTail
        }
        
        novelImageView.do {
            $0.image = .imgTest
            $0.layer.shadowColor = UIColor.wssBlack.cgColor
            $0.layer.shadowOpacity = 0.1
            $0.layer.shadowRadius = 15.44
            $0.layer.shadowOffset = CGSize(width: 0, height: 2.06)
        }
        
        blurBackgroundView.do {
            $0.frame = UIScreen.main.bounds
            $0.backgroundColor = .wssWhite.withAlphaComponent(0.4)
            let blurEffect = UIBlurEffect(style: .regular)
            let visualEffectView = UIVisualEffectView(effect: blurEffect)
            visualEffectView.frame = $0.bounds
            $0.addSubview(visualEffectView)
        }
        
        userProfileView.do {
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
            $0.addSubview(UIImageView(image: .imgTest))
        }
        
        commentTitleLabel.do {
            $0.font = .Title2
            $0.textColor = .wssGray300
            $0.makeAttribute(with: "일이삼사오육칠팔구십 님의 리뷰")?
                .kerning(kerningPixel: -0.6)
                .lineSpacing(spacingPercentage: 140)
                .applyAttribute()
        }
        
        commaStartedImageView.do {
            $0.image = .icCommasStarted
        }
        
        commaFinishedImageView.do {
            $0.image = .icCommasFinished
        }
        
        commentContentLabel.do {
            $0.font = .Label1
            $0.textColor = .wssGray300
            $0.makeAttribute(with: "상수리 나무 아래는 ㄹㅇ 아마 제 인생작이 될꺼 같네요. 소장본도 사려고요 근데 약간 여주가 답답한 스타일인데 그거를 살려버린다 우왕")?
                .kerning(kerningPixel: -0.4)
                .lineSpacing(spacingPercentage: 145)
                .applyAttribute()
            $0.numberOfLines = 3
            $0.lineBreakStrategy = .hangulWordPriority
            $0.lineBreakMode = .byTruncatingTail
        }
    }
    
    private func setHierarchy() {
        self.addSubview(backgroundImageView)
        backgroundImageView.addSubviews(bestTagImageView,
                                        novelTitleLabel,
                                        novelImageView,
                                        blurBackgroundView)
        blurBackgroundView.addSubviews(userProfileView,
                                       commentTitleLabel,
                                       commaStartedImageView,
                                       commentContentLabel,
                                       commaFinishedImageView)
    }
    
    private func setLayout() {
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        bestTagImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
        }
        
        novelTitleLabel.snp.makeConstraints {
            $0.top.equalTo(bestTagImageView.snp.bottom).offset(7)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(233)
        }
        
        novelImageView.snp.makeConstraints {
            $0.top.equalTo(novelTitleLabel.snp.bottom).offset(15)
            $0.centerX.equalToSuperview()
        }
        
        blurBackgroundView.snp.makeConstraints {
            $0.height.equalTo(139)
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        userProfileView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(18)
            $0.size.equalTo(24)
        }
        commentTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(19)
            $0.centerX.equalToSuperview()
        }
        
        commaStartedImageView.snp.makeConstraints {
            $0.top.equalTo(commentTitleLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(16)
        }
        
        commentContentLabel.snp.makeConstraints {
            $0.top.equalTo(commaStartedImageView.snp.top)
            $0.leading.equalTo(commaStartedImageView.snp.trailing).offset(6)
            $0.width.equalTo(204)
        }
        
        commaFinishedImageView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(24)
            $0.leading.equalTo(commentContentLabel.snp.trailing).offset(6)
        }
    }
    
    func bindData() {
        
    }
}
