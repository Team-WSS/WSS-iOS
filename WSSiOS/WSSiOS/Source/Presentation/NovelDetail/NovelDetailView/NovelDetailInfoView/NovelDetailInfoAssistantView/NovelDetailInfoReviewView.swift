//
//  NovelDetailInfoReviewView.swift
//  WSSiOS
//
//  Created by 이윤학 on 7/1/24.
//

import UIKit

import SnapKit
import Then

final class NovelDetailInfoReviewView: UIView {
    
    //MARK: - UI Components
    
    private let reviewStackView = UIStackView()
    private let titleLabel = UILabel()
    private let attractivePointView = NovelDetailInfoReviewAttractivePointView()
    let keywordView = NovelDetailInfoReviewKeywordView()
    private let dividerView = UIView()
    private let graphStackView = NovelDetailInfoReviewGraphStackView()
    
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
        
        reviewStackView.do {
            $0.axis = .vertical
            
            titleLabel.do {
                $0.applyWSSFont(.title1,
                                with: StringLiterals.NovelDetail.Info.attractivePoint)
                $0.textColor = .wssBlack
            }
            
            dividerView.do {
                $0.backgroundColor = .wssGray50
            }
        }
    }
    
    private func setHierarchy() {
        self.addSubview(reviewStackView)
        reviewStackView.addArrangedSubviews(titleLabel,
                                            attractivePointView,
                                            keywordView,
                                            dividerView,
                                            graphStackView)
    }
    
    private func setLayout() {
        reviewStackView.do {
            $0.setCustomSpacing(15, after: titleLabel)
            $0.setCustomSpacing(10, after: attractivePointView)
            $0.setCustomSpacing(40, after: keywordView)
            $0.setCustomSpacing(35, after: dividerView)
            
            $0.snp.makeConstraints {
                $0.top.equalToSuperview().inset(35)
                $0.horizontalEdges.equalToSuperview()
                $0.bottom.equalToSuperview().inset(80)
            }
            
            titleLabel.snp.makeConstraints {
                $0.horizontalEdges.equalToSuperview().inset(20)
            }
            
            attractivePointView.snp.makeConstraints {
                $0.horizontalEdges.equalToSuperview()
            }
            
            keywordView.snp.makeConstraints {
                $0.horizontalEdges.equalToSuperview()
            }
            
            dividerView.snp.makeConstraints {
                $0.horizontalEdges.equalToSuperview()
                $0.height.equalTo(1)
            }
            
            graphStackView.snp.makeConstraints {
                $0.horizontalEdges.equalToSuperview()
            }
        }
    }
    
    //MARK: - Data
    
    func bindData(_ data: NovelDetailInfoResult) {
        attractivePointView.bindData(data)
        graphStackView.bindData(data)
    }
    
    func bindVisibility(_ visibilities: [ReviewSectionVisibility]) {
        let attractiveVisible = visibilities.contains(.attractivepoint)
        let keywordVisible = visibilities.contains(.keyword)
        let graphVisible = visibilities.contains(.graph)
        
        attractivePointView.isHidden = !attractiveVisible
        keywordView.isHidden = !keywordVisible
        graphStackView.isHidden = !graphVisible
        
        if attractiveVisible && !keywordVisible {
            reviewStackView.setCustomSpacing(40, after: attractivePointView)
        }
        
        titleLabel.isHidden = !attractiveVisible && !keywordVisible
        dividerView.isHidden = !((attractiveVisible || keywordVisible) && graphVisible)
        
    }
}
