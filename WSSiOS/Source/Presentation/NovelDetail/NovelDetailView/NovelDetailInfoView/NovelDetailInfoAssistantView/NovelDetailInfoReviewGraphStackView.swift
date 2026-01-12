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
    private let graphViews = ReadStatus.allCases.map {
        NovelDetailInfoReviewGraphView(readStatus: $0)
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
    
    func bindData(_ data: NovelDetailInfoEntity) {
        let titleText = "\(data.topReadStatusCount)"
                        + StringLiterals.NovelDetail.Info.readStatus
                        + data.topReadStatus.graphSectionTitle
        
        let wssFont = WSSFont.title1
        titleLabel.do {
            $0.font = wssFont.font
            $0.textColor = .wssBlack
            $0.makeAttribute(with: titleText)?
                .lineHeight(wssFont.lineHeightMultiple)
                .kerning(kerningPixel: wssFont.kerningPixel)
                .partialColor(color: .wssPrimary100,
                              rangeString: "\(data.topReadStatusCount)명")
                .applyAttribute()
            $0.numberOfLines = 2
        }
        
        graphViews.forEach {
            if let statusCount = data.readStatusCounts[$0.readStatus] {
                $0.bindData(statusCount: statusCount,
                            topStatusCount: data.topReadStatusCount)
            }
        }
    }
}
