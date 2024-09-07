//
//  NovelDetailInfoReviewGraphStackView.swift
//  WSSiOS
//
//  Created by YunhakLee on 8/16/24.
//

import UIKit

import SnapKit
import Then

final class NovelDetailInfoReviewGraphStackView: UIView {
    
    //MARK: - UI Components
    
    private let titleLabel = UILabel()
    private let graphStackView = UIStackView()
    private let graphViews = ReadStatus.allCases.map { _ in
        NovelDetailInfoReviewGraphView()
    }
    
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
        graphStackView.do {
            $0.axis = .horizontal
            $0.spacing = 60
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(titleLabel,
                         graphStackView)
        graphViews.forEach { graphView in
            graphStackView.addArrangedSubview(graphView)
        }
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        graphStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
            $0.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
    }
    
    //MARK: - Data
    
    func bindData(_ data: NovelDetailInfoResult) {
        let topReadStatusCount = getTopReadStatusCount(data)
        let topReadStatusText = getTopReadStatusText(data)
        let titleText = "\(topReadStatusCount)"
                        + StringLiterals.NovelDetail.Info.readStatus
                        + topReadStatusText
        
        titleLabel.do {
            $0.font = .Title1
            $0.textColor = .wssBlack
            $0.makeAttribute(with: titleText)?
                .lineHeight(1.4)
                .kerning(kerningPixel: -0.6)
                .partialColor(color: .wssPrimary100,
                              rangeString: "\(topReadStatusCount)명")
                .applyAttribute()
            $0.numberOfLines = 2
        }
        
        let statusCounts = [data.watchingCount, data.watchedCount, data.quitCount]
        
        for i in 0..<ReadStatus.allCases.count {
            graphViews[i].bindData(statusText: ReadStatus.allCases[i].nameText,
                                   statusCount: statusCounts[i],
                                   maxCount: topReadStatusCount)
        }
    }
    
    //MARK: - Custom Methode
    
    private func getTopReadStatusCount(_ data: NovelDetailInfoResult) -> Int {
        return max(data.quitCount, data.watchedCount, data.watchingCount)
    }
    
    private func getTopReadStatusText(_ data: NovelDetailInfoResult) -> String {
        let maxCount = getTopReadStatusCount(data)
        
        switch maxCount {
        case data.quitCount:
            return StringLiterals.NovelDetail.Info.ReadStatus.quit
        case data.watchedCount:
            return StringLiterals.NovelDetail.Info.ReadStatus.watched
        case data.watchingCount:
            return StringLiterals.NovelDetail.Info.ReadStatus.watching
        default:
            return StringLiterals.NovelDetail.Info.ReadStatus.quit
        }
    }
}
