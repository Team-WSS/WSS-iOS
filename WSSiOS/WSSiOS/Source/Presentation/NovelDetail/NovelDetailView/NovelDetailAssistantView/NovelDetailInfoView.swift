//
//  NovelDetailInfoView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 1/11/24.
//

import UIKit

import SnapKit
import Then

final class NovelDetailInfoView: UIView {

    // MARK: - Components
    
    let contentView = UIStackView()
    let novelDetailInfoRatingView = NovelDetailInfoRatingView()
    let novelDetailInfoReadStatusView = NovelDetailInfoReadStatusView()
    let novelDetailInfoReadDateView = NovelDetailInfoReadDateView()
    let novelDetailInfoDescriptionView = NovelDetailInfoDescriptionView()
    let novelDetailInfoGenreView = NovelDetailInfoGenreView()
    let novelDetailInfoPlatformView = NovelDetailInfoPlatformView()

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
        contentView.do {
            $0.alignment = .fill
            $0.axis = .vertical
        }
    }
    
    private func setHierarchy() {
        self.addSubview(contentView)
        contentView.addArrangedSubviews(novelDetailInfoRatingView,
                                        novelDetailInfoReadStatusView,
                                        novelDetailInfoReadDateView,
                                        novelDetailInfoDescriptionView,
                                        novelDetailInfoGenreView,
                                        novelDetailInfoPlatformView)
    }
    
    private func setLayout() {
        contentView.snp.makeConstraints {
            $0.top.leading.trailing.width.equalToSuperview()
            $0.bottom.equalToSuperview().inset(110)
        }
    }
    
    // MARK: - Data
    
    func bindData(rating: Float, readStatus: String, startDate: String?, endDate: String?, description: String, genre: String, platforms: [UserNovelPlatform]) {
        self.novelDetailInfoRatingView.bindData(rating: rating)
        self.novelDetailInfoReadStatusView.bindData(status: readStatus)
        if let startDate = startDate {
            self.novelDetailInfoReadDateView.bindData(startDate: startDate, endDate: endDate)
        } else {
            self.novelDetailInfoReadDateView.removeFromSuperview()
        }
        self.novelDetailInfoDescriptionView.bindData(description: description)
        self.novelDetailInfoGenreView.bindData(genre: genre)
        self.novelDetailInfoPlatformView.bindData(platforms: platforms)
    }
}
