//
//  NovelDetailInfoView.swift
//  WSSiOS
//
//  Created by 이윤학 on 6/23/24.
//

import UIKit

import SnapKit
import Then

final class NovelDetailInfoView: UIView {
    
    //MARK: - Components
    
    private let stackView = UIStackView()
    let descriptionView = NovelDetailInfoDescriptionView()
    let platformView = NovelDetailInfoPlatformView()
    let reviewEmptyView = NovelDetailInfoReviewEmptyView()
    let reviewView = NovelDetailInfoReviewView()
    
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
        self.backgroundColor = .wssGray50
        
        stackView.do {
            $0.axis = .vertical
            $0.alignment = .fill
        }
    }
    
    private func setHierarchy() {
        self.addSubview(stackView)
        stackView.addArrangedSubviews(descriptionView,
                                      platformView,
                                      reviewEmptyView,
                                      reviewView)
    }
    
    private func setLayout() {
        stackView.do {
            $0.snp.makeConstraints {
                $0.top.equalToSuperview()
                $0.bottom.equalToSuperview()
                $0.horizontalEdges.equalToSuperview()
            }
            
            $0.setCustomSpacing(1, after: descriptionView)
            $0.setCustomSpacing(7, after: platformView)
        }
    }
    
    //MARK: - Data
    
    func bindData(_ data: NovelDetailInfoResult) {
        descriptionView.bindData(data)
        reviewView.bindData(data)
    }
    
    func updateVisibility(_ visibilities: [ReviewSectionVisibility]) {
        if visibilities.isEmpty {
            reviewView.isHidden = true
            reviewEmptyView.isHidden = false
        } else {
            reviewView.isHidden = false
            reviewEmptyView.isHidden = true
            reviewView.bindVisibility(visibilities)
        }
    }
}
