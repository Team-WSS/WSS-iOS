//
//  NovelReviewStatusView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 8/28/24.
//

import UIKit

import SnapKit
import Then

final class NovelReviewStatusView: UIView {
    
    //MARK: - Components
    
    let statusCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    let dateLabel = UILabel()
    private let dateFormatter = DateFormatter()
    
    //MARK: - Life Cycle
    
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
        self.do {
            $0.backgroundColor = .wssWhite
        }
        
        statusCollectionView.do {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.minimumInteritemSpacing = 0
            layout.itemSize = CGSize(width: 105, height: 78)
            
            $0.collectionViewLayout = layout
            $0.isScrollEnabled = false
        }
        
        dateLabel.do {
            $0.applyWSSFontWithUnderLine(.body4_2, with: StringLiterals.NovelReview.Date.addDate)
            $0.textColor = .wssGray200
        }
        
        dateFormatter.do {
            $0.dateFormat = "yy년 M월 d일"
            $0.timeZone = TimeZone(identifier: "ko_KR")
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(statusCollectionView,
                         dateLabel)
    }
    
    private func setLayout() {
        statusCollectionView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(45)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(315)
            $0.height.equalTo(78)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(statusCollectionView.snp.bottom).offset(17.5)
            $0.bottom.equalToSuperview().inset(30)
            $0.centerX.equalToSuperview()
        }
    }
    
    //MARK: - Data
    
    func bindData(readStatus: ReadStatus, startDate: Date?, endDate: Date?) {
        if startDate == nil && endDate == nil {
            dateLabel.do {
                $0.applyWSSFontWithUnderLine(.body4_2, with: StringLiterals.NovelReview.Date.addDate)
            }
        } else {
            var startDateString = startDate.map { dateFormatter.string(from: $0) } ?? ""
            var endDateString = endDate.map { dateFormatter.string(from: $0) } ?? ""
            
            switch readStatus {
            case .watching:
                endDateString = ""
            case .quit:
                startDateString = ""
            default:
                break
            }

            dateLabel.do {
                $0.applyWSSFontWithUnderLine(.body4_2, with: "\(startDateString) ~ \(endDateString)")
            }
        }
    }
}
