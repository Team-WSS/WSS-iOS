//
//  MyLibraryTableViewCell.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 6/27/25.
//

import UIKit

import SnapKit
import Then

final class MyLibraryTableViewCell: UITableViewCell {
    
    //MARK: - Components
    
    private let stackView = UIStackView()
    
    private let novelInfoContentView = UIView()
    private let novelImageStackView = UIStackView()
    private let readStatusTagView = MyLibraryReadStatusTagView()
    private let novelImageView = UIImageView()
    private let interestImageView = UIImageView()
    private let dateLabel = UILabel()
    
    private let textStackView = UIStackView()
    private let novelTitleLabel = UILabel()
    private let ratingStackView = UIStackView()
    private let myRatingStackView = UIStackView()
    private let myRatingImageView = UIImageView()
    private let myRatingNumberLabel = UILabel()
    private let myRatingLabel = UILabel()
    private let totalRatingStackView = UIStackView()
    private let totalRatingImageView = UIImageView()
    private let totalRatingNumberLabel = UILabel()
    private let totalRatingLabel = UILabel()
    private let attractivePointStackView = UIStackView()
    
    private let keywordScrollView = UIScrollView()
    private let keywordStackView = UIStackView()
    private let feedScrollView = UIScrollView()
    private let feedStackView = UIStackView()
    
    private let separatorView = UIView()
    
    //MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI
    
    private func setUI() {
        self.do {
            $0.selectionStyle = .none
        }
        
        stackView.do {
            $0.axis = .vertical
            $0.alignment = .fill
        }
        
        novelImageStackView.do {
            $0.axis = .vertical
            $0.spacing = 0
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
        }
        
        novelImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
        }
        
        dateLabel.do {
            $0.textColor = .wssGray300
        }
        
        interestImageView.do {
            $0.image = .icNovelInterest
        }
        
        textStackView.do {
            $0.axis = .vertical
            $0.alignment = .leading
        }
        
        novelTitleLabel.do {
            $0.textColor = .wssBlack
            $0.lineBreakMode = .byTruncatingTail
        }
        
        ratingStackView.do {
            $0.axis = .horizontal
            $0.spacing = 7
            $0.alignment = .center
        }
        
        myRatingStackView.do {
            $0.axis = .horizontal
            $0.alignment = .center
        }
        
        myRatingImageView.do {
            $0.image = .icSmallStarFilled
        }
        
        myRatingNumberLabel.do {
            $0.textColor = .wssSecondary100
        }
        
        myRatingLabel.do {
            $0.applyWSSFont(.body5, with: "내 별점")
            $0.textColor = .wssGray300
        }
        
        totalRatingStackView.do {
            $0.axis = .horizontal
            $0.alignment = .center
        }
        
        totalRatingImageView.do {
            $0.image = .icSmallStarFilled.withTintColor(.wssGray200)
        }
        
        totalRatingNumberLabel.do {
            $0.textColor = .wssGray200
        }
        
        totalRatingLabel.do {
            $0.applyWSSFont(.body5, with: "전체 별점")
            $0.textColor = .wssGray200
        }
        
        attractivePointStackView.do {
            $0.axis = .horizontal
            $0.spacing = 8
            $0.alignment = .center
        }
        
        keywordScrollView.do {
            $0.showsHorizontalScrollIndicator = false
        }
        
        keywordStackView.do {
            $0.axis = .horizontal
            $0.spacing = 6
        }
        
        feedScrollView.do {
            $0.showsHorizontalScrollIndicator = false
        }
        
        feedStackView.do {
            $0.axis = .horizontal
            $0.spacing = 12
            $0.distribution = .fill
        }
        
        separatorView.do {
            $0.backgroundColor = .wssGray50
        }
    }
    
    private func setHierarchy() {
        contentView.addSubviews(stackView,
                                separatorView)
        stackView.addArrangedSubviews(novelInfoContentView,
                                      keywordScrollView,
                                      feedScrollView)
        novelInfoContentView.addSubviews(novelImageStackView,
                                         textStackView,
                                         interestImageView,
                                         dateLabel)
        novelImageStackView.addArrangedSubviews(readStatusTagView,
                                                novelImageView)
        textStackView.addArrangedSubviews(novelTitleLabel,
                                          ratingStackView,
                                          attractivePointStackView)
        ratingStackView.addArrangedSubviews(myRatingStackView,
                                            totalRatingStackView)
        myRatingStackView.addArrangedSubviews(myRatingImageView,
                                              myRatingNumberLabel,
                                              myRatingLabel)
        totalRatingStackView.addArrangedSubviews(totalRatingImageView,
                                                 totalRatingNumberLabel,
                                                 totalRatingLabel)
                                            
        keywordScrollView.addSubview(keywordStackView)
        feedScrollView.addSubview(feedStackView)
    }
    
    private func setLayout() {
        stackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.verticalEdges.equalToSuperview().inset(16)
            
            stackView.setCustomSpacing(8, after: novelInfoContentView)
            stackView.setCustomSpacing(12, after: keywordScrollView)
        }
        
        separatorView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        novelImageStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
            $0.width.equalTo(60)
            
            readStatusTagView.snp.makeConstraints() {
                $0.width.equalTo(60)
                $0.height.equalTo(18)
            }
            
            novelImageView.snp.makeConstraints() {
                $0.width.equalTo(60)
                $0.height.equalTo(80)
            }
        }
        
        interestImageView.snp.makeConstraints() {
            $0.trailing.equalTo(novelImageStackView.snp.trailing).offset(-7)
            $0.bottom.equalTo(novelImageStackView.snp.bottom).offset(-7)
        }
        
        dateLabel.snp.makeConstraints() {
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
        }
        
        textStackView.snp.makeConstraints() {
            $0.top.equalTo(novelImageView.snp.top).offset(5)
            $0.leading.equalTo(novelImageStackView.snp.trailing).offset(16)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        textStackView.setCustomSpacing(2, after: novelTitleLabel)
        textStackView.setCustomSpacing(6, after: ratingStackView)
        
        myRatingImageView.snp.makeConstraints() {
            $0.size.equalTo(9)
        }
        
        myRatingStackView.setCustomSpacing(3.5, after: myRatingImageView)
        myRatingStackView.setCustomSpacing(5, after: myRatingNumberLabel)
        
        totalRatingImageView.snp.makeConstraints {
            $0.size.equalTo(9)
        }
        
        totalRatingStackView.setCustomSpacing(3.5, after: totalRatingImageView)
        totalRatingStackView.setCustomSpacing(5, after: totalRatingNumberLabel)
        
        keywordScrollView.snp.makeConstraints {
            $0.height.equalTo(31)
        }
        
        keywordStackView.snp.makeConstraints {
            $0.height.equalTo(31)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        feedScrollView.snp.makeConstraints {
            $0.height.equalTo(54)
        }
        
        feedStackView.snp.makeConstraints {
            $0.height.equalTo(54)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    //MARK: - Data
    
    func bindData(_ data: MyLibraryEntity) {
        if let readStatus = data.readStatus {
            readStatusTagView.isHidden = false
            readStatusTagView.bindData(readStatus: readStatus)
        } else {
            readStatusTagView.isHidden = true
        }
        novelImageView.kfSetImage(url: data.novelImage)
        interestImageView.isHidden = !data.isInterest
        
        if let startDate = data.startDate, let endDate = data.endDate {
            dateLabel.isHidden = false
            dateLabel.applyWSSFont(.body5, with: "\(startDate) ~ \(endDate)")
        } else if let startDate = data.startDate {
            dateLabel.isHidden = false
            dateLabel.applyWSSFont(.body5, with: startDate)
        } else if let endDate = data.endDate {
            dateLabel.isHidden = false
            dateLabel.applyWSSFont(.body5, with: endDate)
        } else {
            dateLabel.isHidden = true
        }
        
        novelTitleLabel.applyWSSFont(.title2, with: data.title)
        
        if data.userNovelRating > 0.0 {
            myRatingStackView.isHidden = false
            myRatingNumberLabel.applyWSSFont(.body5_2, with: "\(data.userNovelRating)")
        } else {
            myRatingStackView.isHidden = true
        }
        
        if data.novelRating > 0.0 {
            totalRatingStackView.isHidden = false
            totalRatingNumberLabel.applyWSSFont(.body5_2, with: "\(data.novelRating)")
        } else {
            totalRatingStackView.isHidden = true
        }
        
        attractivePointStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        if data.attractivePoints.isEmpty {
            attractivePointStackView.isHidden = true
        } else {
            attractivePointStackView.isHidden = false
            for (index, point) in data.attractivePoints.enumerated() {
                guard let point else { continue }

                let attractivePointView = UIStackView()
                attractivePointView.axis = .horizontal
                attractivePointView.spacing = 3
                attractivePointView.alignment = .center
                
                let attractivePointImageView = UIImageView()
                attractivePointImageView.image = point.image.withRenderingMode(.alwaysTemplate)
                attractivePointImageView.tintColor = .wssPrimary100
                attractivePointImageView.snp.makeConstraints {
                    $0.size.equalTo(12)
                }
                
                let attractivePointLabel = UILabel()
                attractivePointLabel.applyWSSFont(.body5, with: point.koreanString)
                attractivePointLabel.textColor = .wssGray300
                
                attractivePointView.addArrangedSubviews(attractivePointImageView,
                                                        attractivePointLabel)
                attractivePointStackView.addArrangedSubview(attractivePointView)
                
                if index < data.attractivePoints.count - 1 {
                    let dotView = UIView()
                    dotView.backgroundColor = .wssPrimary100
                    dotView.layer.cornerRadius = 1
                    dotView.snp.makeConstraints {
                        $0.size.equalTo(2)
                    }
                    attractivePointStackView.addArrangedSubview(dotView)
                }
            }
        }
        
        keywordStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        if data.keywords.isEmpty {
            keywordScrollView.isHidden = true
        } else {
            keywordScrollView.isHidden = false
            data.keywords.forEach { keyword in
                let keywordView = UIView()
                keywordView.backgroundColor = .wssPrimary20
                keywordView.layer.cornerRadius = 31 / 2
                keywordView.clipsToBounds = true
                let keywordLabel = UILabel()
                keywordLabel.applyWSSFont(.body4, with: keyword)
                keywordLabel.textColor = .wssGray200
                
                keywordView.addSubview(keywordLabel)
                keywordStackView.addArrangedSubview(keywordView)
                
                keywordView.snp.makeConstraints {
                    $0.height.equalTo(31)
                }
                keywordLabel.snp.makeConstraints {
                    $0.centerY.equalToSuperview()
                    $0.leading.trailing.equalToSuperview().inset(8)
                }
            }
        }
        
        feedStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        if data.myFeeds.isEmpty {
            feedScrollView.isHidden = true
        } else {
            feedScrollView.isHidden = false
            data.myFeeds.forEach { feed in
                let feedView = MyLibraryMyFeedView()
                feedView.bindData(feed: feed)
                feedView.snp.makeConstraints {
                    $0.height.equalTo(54)
                }
                feedStackView.addArrangedSubview(feedView)
            }
        }
    }
}
