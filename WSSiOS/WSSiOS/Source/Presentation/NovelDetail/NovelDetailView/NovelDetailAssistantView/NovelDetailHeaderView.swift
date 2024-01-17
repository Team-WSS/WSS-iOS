//
//  NovelDetailHeaderView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 1/11/24.
//

import UIKit

import Kingfisher
import SnapKit
import Then
import UIImageViewAlignedSwift

final class NovelDetailHeaderView: UIView {

    // MARK: - UI Components
    
    private let backgroundImageView = UIImageViewAligned()
    private let gradientView = UIImageView()
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
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.alignment = .top
        }
        
        gradientView.do {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.image = ImageLiterals.Image.Banner.backgroundGradient
        }
        
        genreImageView.do {
            $0.contentMode = .scaleAspectFit
        }
        
        novelTitleLabel.do {
            $0.font = .HeadLine1
            $0.textColor = .White
            $0.numberOfLines = 3
            $0.lineBreakMode = .byTruncatingTail
            $0.lineBreakStrategy = .hangulWordPriority
        }
        
        novelAuthorLabel.do {
            $0.font = .Body2
            $0.textColor = .Gray200
            $0.lineBreakMode = .byTruncatingTail
        }
        
        novelCoverImageView.do {
            $0.layer.cornerRadius = 6
            $0.clipsToBounds = true
        }
    }
    
    // MARK: - set Hierachy
    
    private func setHierachy() {
        self.addSubviews(backgroundImageView,
                         gradientView,
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
        
        gradientView.snp.makeConstraints {
            $0.edges.equalTo(backgroundImageView.snp.edges)
        }
        
        genreImageView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(27)
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
    
    func bindData(title: String, author: String, novelImage: String, genreImage: String) {
        self.novelTitleLabel.text = title
        self.novelAuthorLabel.text = author
        self.novelCoverImageView.kf.setImage(with: URL(string: novelImage))
        self.genreImageView.kf.setImage(with: URL(string: genreImage))
        if let novelImageUrl = URL(string: novelImage) {
            KingfisherManager.shared.retrieveImage(with: novelImageUrl, completionHandler: { result in
            switch(result) {
            case .success(let imageResult):
                let blurredImage = imageResult.image.asBlurredBannerImage(radius: 3)
                self.backgroundImageView.image = blurredImage
            case .failure(let error):
                print(error)
                }
            })
        }
    }
}
