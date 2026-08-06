//
//  HomeTodayPopularCollectionViewCell.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 4/15/24.
//

import UIKit

import Kingfisher
import UIImageViewAlignedSwift
import RxSwift

final class HomeTodayPopularCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    private let blurRadius: CGFloat = 8
    private var disposeBag = DisposeBag()

    // 플레이스홀더 블러 이미지는 항상 동일한 결과이므로 앱 생애주기 동안 한 번만 계산
    private static let blurredPlaceholderImage: UIImage = .imgLoadingThumbnail.asBlurredBannerImage(radius: 8)
    
    //MARK: - Components
  
    /// 셀 배경
    private let backgroundNovelImageView = UIImageViewAligned()
    private let gradation = UIImageView()
    
    /// 소설 정보
    private let novelStackView = UIStackView()
    private let novelTitleLabel = UILabel()
    private let novelAuthorandCompletedLabel = UILabel()
    private let keywordStackView = UIStackView()
    private let novelImageContainerView = UIView()
    private let novelImageView = UIImageView()
    private let novelGenreBackgroundView = UIImageView()
    private let novelGenreImageView = UIImageView()
    
    /// 유저 피드 글 정보
    private let blurBackgroundView = UIView()
    private let userProfileView = UIImageView()
    private let introductionImageView = UIImageView()
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        novelImageContainerView.layer.shadowPath = UIBezierPath(
            roundedRect: novelImageContainerView.bounds,
            cornerRadius: 5.65
        ).cgPath
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        backgroundNovelImageView.image = nil
    }
    
    //MARK: - UI
    
    private func setUI() {
        self.layer.cornerRadius = 14
        self.clipsToBounds = true

        backgroundNovelImageView.do {
            $0.image = Self.blurredPlaceholderImage
            $0.contentMode = .scaleAspectFill
            $0.alignment = .top
            $0.clipsToBounds = true
            
            gradation.do {
                $0.image = .imgNovelBg
                $0.contentMode = .scaleToFill
                $0.clipsToBounds = true
            }
        }
        
        novelStackView.do {
            $0.axis = .vertical
            $0.spacing = 4
        }
        
        keywordStackView.do {
            $0.axis = .vertical
            $0.spacing = 4
            $0.alignment = .leading
        }

        novelTitleLabel.do {
            $0.textColor = .wssBlack
            $0.numberOfLines = 2
        }
        
        novelAuthorandCompletedLabel.do {
            $0.textColor = .wssGray200
            $0.numberOfLines = 1
        }
        
        novelImageContainerView.do {
            $0.backgroundColor = .clear
            $0.layer.shadowColor = UIColor.wssBlack.cgColor
            $0.layer.shadowOpacity = 0.1
            $0.layer.shadowRadius = 10.59
            $0.layer.shadowOffset = CGSize(width: 0, height: 1.41)
        }
        
        novelImageView.do {
            $0.image = .imgLoadingThumbnail
            $0.layer.cornerRadius = 5.65
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
        }
        
        novelGenreBackgroundView.do {
            $0.contentMode = .scaleAspectFit
            $0.image = .icGenreBackground
        }
        
        novelGenreImageView.do {
            $0.contentMode = .scaleAspectFit
            $0.image = .icGenreRF
        }
        
        blurBackgroundView.do {
            $0.frame = UIScreen.main.bounds
            $0.backgroundColor = .wssWhite.withAlphaComponent(0.7)
            let blurEffect = UIBlurEffect(style: .regular)
            let visualEffectView = UIVisualEffectView(effect: blurEffect)
            visualEffectView.frame = $0.bounds
            $0.addSubview(visualEffectView)
        }
        
        userProfileView.do {
            $0.layer.cornerRadius = 8
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
        }
        
        introductionImageView.do {
            $0.image = .icIntroduction
            $0.contentMode = .scaleAspectFit
        }
        
        commentTitleLabel.do {
            $0.textColor = .wssGray300
        }
        
        commaStartedImageView.do {
            $0.image = .icCommasStarted
        }
        
        commaFinishedImageView.do {
            $0.image = .icCommasFinished
        }
        
        commentContentLabel.do {
            $0.textColor = .wssGray300
            $0.numberOfLines = 3
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(backgroundNovelImageView,
                         novelStackView,
                         novelImageContainerView,
                         novelGenreBackgroundView,
                         keywordStackView,
                         blurBackgroundView)
        backgroundNovelImageView.addSubview(gradation)
        novelImageContainerView.addSubview(novelImageView)
        novelStackView.addArrangedSubviews(
            novelTitleLabel,
            novelAuthorandCompletedLabel
        )
        novelGenreBackgroundView.addSubview(novelGenreImageView)
        blurBackgroundView.addSubviews(userProfileView,
                                       introductionImageView,
                                       commentTitleLabel,
                                       commaStartedImageView,
                                       commentContentLabel,
                                       commaFinishedImageView)
    }
    
    private func setLayout() {
        backgroundNovelImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        gradation.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        novelStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(33)
            $0.leading.equalToSuperview().inset(19)
        }
        
        novelImageContainerView.snp.makeConstraints {
            $0.top.equalTo(novelStackView.snp.top)
            $0.leading.equalTo(novelStackView.snp.trailing).offset(14)
            $0.trailing.equalToSuperview().inset(22)
            $0.width.equalTo(117)
            $0.height.equalTo(171)
        }
        
        novelImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        novelGenreBackgroundView.snp.makeConstraints {
            $0.trailing.bottom.equalTo(novelImageView)
            $0.size.equalTo(56)
        }

        novelGenreImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(3)
            $0.bottom.equalToSuperview().inset(5)
            $0.size.equalTo(25)
        }
        
        blurBackgroundView.snp.makeConstraints {
            $0.height.equalTo(139)
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        keywordStackView.snp.makeConstraints {
            $0.bottom.equalTo(blurBackgroundView.snp.top).offset(-22)
            $0.leading.equalToSuperview().inset(19)
        }
        
        userProfileView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(18)
            $0.size.equalTo(24)
        }
        
        introductionImageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(18)
            $0.size.equalTo(18)
        }
        
        commentTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(19)
            $0.leading.equalTo(userProfileView.snp.trailing).offset(10)
        }
        
        commaStartedImageView.snp.makeConstraints {
            $0.top.equalTo(commentTitleLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(18)
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
    
    func bindData(data: TodayDiscoveryNovel) {
        self.novelTitleLabel.do {
            $0.applyWSSFont(.title2, with: data.title.truncateText(maxLength: 17))
            $0.lineBreakMode = .byTruncatingTail
            $0.textAlignment = .left
            $0.lineBreakStrategy = .hangulWordPriority
        }
        self.novelAuthorandCompletedLabel.do {
            let author = data.author.truncateText(maxLength: 5)
            let completed = data.isNovelCompleted ? "완결작" : "연재작"
            $0.applyWSSFont(.body3, with: "\(author) · \(completed)")
        }
        
        keywordStackView.arrangedSubviews.forEach {
            keywordStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        keywordStackView.isHidden = data.keywords.isEmpty
        data.keywords.forEach { keyword in
            let chip = HomeTodayDiscoveryKeywordChip()
            chip.setText(keyword)
            keywordStackView.addArrangedSubview(chip)
        }
        // 썸네일과 배경 블러가 동일한 이미지를 쓰므로, 네트워크 요청을 한 번만 보내고
        // 완료 콜백에서 받은 이미지로 블러 배경까지 함께 채운다 (중복 요청 제거)
        if let imageURL = URL(string: data.novelImage) {
            self.novelImageView.kf.indicatorType = .activity
            self.novelImageView.kf.setImage(
                with: imageURL,
                placeholder: nil,
                options: [.transition(.fade(1.0))]
            ) { [weak self] result in
                guard let self, case .success(let imageResult) = result else { return }
                imageResult.image.asBlurredBannerImage(radius: self.blurRadius) { [weak self] blurred in
                    self?.backgroundNovelImageView.image = blurred
                }
            }
        }

        self.novelGenreImageView.image = NovelGenre.allCases
            .first(where: { $0.rawValue == data.genreName })?.image

        self.commentContentLabel.do {
            $0.lineBreakStrategy = .hangulWordPriority
            $0.lineBreakMode = .byTruncatingTail
        }
        
        // 대응하는 피드가 존재할 경우
        if let feedContent = data.feedContent,
        let avatarImage = data.avatarImage,
        let nickname = data.nickname {
            self.userProfileView.kfSetImage(url: makeBucketImageURLString(path: avatarImage))
            self.userProfileView.isHidden = false
            self.introductionImageView.isHidden = true
            self.commentTitleLabel.applyWSSFont(.title2, with: "\(nickname)\(StringLiterals.Home.TodayPopular.feed)")
            self.commentTitleLabel.snp.remakeConstraints {
                $0.top.equalTo(userProfileView.snp.top)
                $0.leading.equalTo(userProfileView.snp.trailing).offset(10)
            }
            self.commentContentLabel.applyWSSFont(.label1, with: feedContent)
        }
        // 대응하는 피드 존재 X -> 작품 설명
        else {
            self.userProfileView.isHidden = true
            self.introductionImageView.isHidden = false
            
            self.commentTitleLabel.snp.remakeConstraints {
                $0.top.equalTo(introductionImageView.snp.top).offset(-2)
                $0.leading.equalTo(introductionImageView.snp.trailing).offset(8)
            }
            self.commentTitleLabel.applyWSSFont(.title2, with: StringLiterals.Home.TodayPopular.introduction)
            self.commentContentLabel.applyWSSFont(.label1, with: data.novelDescription)
        }
    }
}
