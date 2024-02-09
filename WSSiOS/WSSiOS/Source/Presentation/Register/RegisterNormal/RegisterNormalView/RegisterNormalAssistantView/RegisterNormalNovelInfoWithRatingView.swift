//
//  NovelInfoWithRatingView.swift
//  WSSiOS
//
//  Created by 이윤학 on 1/7/24.
//

import UIKit

import Kingfisher
import SnapKit
import Then

final class RegisterNormalNovelInfoWithRatingView: UIView {
    
    // MARK: - Components
    
    private let novelInfoWithRatingStackView = UIStackView()
    
    private let novelInfoStackView = UIStackView()
    private let novelTitleLabel = UILabel()
    private let novelAuthorLabel = UILabel()
    
    private let novelCoverImageView = UIImageView()
    private let novelCoverShadowView = UIView()
    
    let starRatingStackView = UIStackView()
    lazy var starImageViews: [UIImageView] = createStars()
    
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
    
    // MARK: - UI
    
    private func setUI() {
        novelInfoWithRatingStackView.do {
            $0.axis = .vertical
            $0.spacing = 22
            $0.alignment = .center
            
            novelInfoStackView.do {
                $0.axis = .vertical
                $0.spacing = 6
                $0.alignment = .center
                
                novelTitleLabel.do {
                    // 로딩 전&후 화면의 이질감을 줄이기 위해 로딩중 문구 추가
                    $0.text = StringLiterals.Loading.novelTitle
                    novelTitleAttribute(of: $0)
                }
                
                novelAuthorLabel.do {
                    // 로딩 전&후 화면의 이질감을 줄이기 위해 추가
                    $0.text = StringLiterals.Loading.novelAuthor
                    novelAuthorAttribute(of: $0)
                }
            }
            
            novelCoverShadowView.do {
                $0.layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
                $0.layer.shadowOpacity = 1
                $0.layer.shadowOffset = CGSize(width: 0, height: 2)
                $0.layer.shadowRadius = 15
                
                novelCoverImageView.do {
                    $0.image = .imgLoadingThumbnail
                    $0.contentMode = .scaleAspectFill
                    $0.layer.cornerRadius = 12
                    $0.clipsToBounds = true
                }
            }
            
            starRatingStackView.do {
                $0.axis = .horizontal
                $0.spacing = 10
            }
        }
    }
    
    private func setHierarchy() {
        self.addSubview(novelInfoWithRatingStackView)
        novelCoverShadowView.addSubview(novelCoverImageView)
        novelInfoWithRatingStackView.addArrangedSubviews(novelInfoStackView,
                                                         novelCoverShadowView,
                                                         starRatingStackView)
        novelInfoStackView.addArrangedSubviews(novelTitleLabel,
                                               novelAuthorLabel)
        starImageViews.forEach {
            starRatingStackView.addArrangedSubview($0)
        }
    }
    
    private func setLayout() {
        novelInfoWithRatingStackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(67)
            
            novelCoverShadowView.snp.makeConstraints {
                $0.height.equalTo(novelCoverShadowView.snp.width).multipliedBy(197.0/128.0)
                $0.horizontalEdges.equalToSuperview().inset(56.5)
            }
            
            novelCoverImageView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
              
            starImageViews.forEach {
                $0.snp.makeConstraints {
                    $0.width.equalTo(31)
                    $0.height.equalTo(31)
                }
            }
        }
    }
    
    // MARK: - Data
    
    func bindData(coverImage: String, title: String?, author: String?) {
        if let url = URL(string: coverImage) {
            novelCoverImageView.kf.setImage(with: url)
        }
        novelTitleLabel.do {
            $0.text = title
            novelTitleAttribute(of: $0)
        }
        novelAuthorLabel.do {
            $0.text = author
            novelAuthorAttribute(of: $0)
        }
    }
    
    // MARK: - Custom Method
    
    /// StarRating 을 위한 별 이미지 5개 생성
    private func createStars() -> [UIImageView] {
        return (0..<5).map { _ in
            let starImageView = UIImageView().then {
                $0.isUserInteractionEnabled = true
                $0.image = .icStarEmpty
                $0.contentMode = .scaleAspectFill
                $0.clipsToBounds = true
            }
            return starImageView
        }
    }
    
    /// StarRating에 따라 별 이미지를 업데이트
    func updateStarImages(rating: Float) {
        let fullStars = Int(rating)
        let hasHalfStar = rating - Float(fullStars) >= 0.5
        
        starImageViews.enumerated().forEach { index, imageView in
            if index < fullStars {
                imageView.image = .icStarFill
            } else if hasHalfStar && index == fullStars {
                imageView.image = .icStarHalf
            } else {
                imageView.image = .icStarEmpty
            }
        }
        print(rating)
    }
    
    /// novelTitle의 UI를 위한 함수.
    private func novelTitleAttribute(of label: UILabel) {
        label.do {
            $0.makeAttribute(with: label.text)?
                .lineSpacing(spacingPercentage: 140)
                .kerning(kerningPixel: -1.2)
                .applyAttribute()
            $0.font = .HeadLine1
            $0.textColor = .wssWhite
            $0.textAlignment = .center
            $0.lineBreakMode = .byTruncatingTail
            $0.lineBreakStrategy = .hangulWordPriority
            $0.numberOfLines = 3
        }
    }
    
    /// novel의 AttributedText 적용을 위한 함수.
    private func novelAuthorAttribute(of label: UILabel) {
        label.do{
            $0.makeAttribute(with: label.text)?
                .lineSpacing(spacingPercentage: 150)
                .kerning(kerningPixel: -0.6)
                .applyAttribute()
            $0.font = .Body2
            $0.textColor = .wssGray200
            $0.numberOfLines = 1
            $0.lineBreakMode = .byTruncatingTail
        }
    }
}
