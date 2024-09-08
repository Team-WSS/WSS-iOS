//
//  NovelDetailInfoReviewAttractivePointView.swift
//  WSSiOS
//
//  Created by 이윤학 on 7/3/24.
//

import UIKit

import SnapKit
import Then

final class NovelDetailInfoReviewAttractivePointView: UIView {
    
    //MARK: - UI Components
    
    private let attractivePointBackgroundView = UIView()
    private let attractivePointLabel = UILabel()
    
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
        attractivePointBackgroundView.do {
            $0.backgroundColor = .wssGray50
            $0.layer.cornerRadius = 12
        }
    }
    
    private func setHierarchy() {
        self.addSubview(attractivePointBackgroundView)
        attractivePointBackgroundView.addSubview(attractivePointLabel)
    }
    
    private func setLayout() {
        attractivePointBackgroundView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.height.equalTo(55)
            $0.horizontalEdges.equalToSuperview().inset(20)
            
            attractivePointLabel.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
        }
    }
    
    //MARK: - Data
    
    func bindData(_ data: NovelDetailInfoResult) {
        let attractivePointText = data.attractivePoints
            .map{ AttractivePoint(rawValue: $0) ?? .error }
            .map{ $0.korean }
            .joined(separator: ", ")
        
        let attractivePointTotalText = attractivePointText
                                       + StringLiterals.NovelDetail.Info.attractivePointDescription
        let wssFont = WSSFont.title3
        
        attractivePointLabel.do {
            $0.font = wssFont.font
            $0.textColor = .wssBlack
            $0.makeAttribute(with: attractivePointTotalText)?
                .lineHeight(wssFont.lineHeightMultiple)
                .kerning(kerningPixel: wssFont.kerningPixel)
                .partialColor(color: .wssPrimary100,
                              rangeString: attractivePointText)
                .applyAttribute()
        }
    }
}
