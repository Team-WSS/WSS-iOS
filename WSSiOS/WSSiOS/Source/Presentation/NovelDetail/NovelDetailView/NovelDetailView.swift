//
//  NovelDetailView.swift
//  WSSiOS
//
//  Created by 이윤학 on 4/25/24.
//

import UIKit

import SnapKit
import Then

final class NovelDetailView: UIView {
    
    //MARK: - Components
    
    let statusBarView = UIView()
    let scrollView = UIScrollView()
    private let contentView = UIStackView()
    
    let headerView = NovelDetailHeaderView()
    let largeNovelCoverImageButton = NovelDetailLargeCoverImageButton()
    
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
        self.backgroundColor = .wssWhite
        
        statusBarView.do {
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
            let statusBarManager = windowScene?.windows.first?.windowScene?.statusBarManager
            $0.frame = statusBarManager?.statusBarFrame ?? .zero
        }
        
        scrollView.do {
            $0.contentInsetAdjustmentBehavior = .never
            $0.showsVerticalScrollIndicator = false
        }
        
        contentView.do {
            $0.alignment = .fill
            $0.axis = .vertical
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(scrollView,
                         statusBarView,
                         largeNovelCoverImageButton)
        scrollView.addSubview(contentView)
        contentView.addArrangedSubview(headerView)
    }
    
    private func setLayout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalToSuperview()
        }
        
        largeNovelCoverImageButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    //MARK: - Data
    
    func bindData(_ data: NovelDetailHeaderResult) {
        headerView.bindData(data)
        largeNovelCoverImageButton.bindData(data)
    }
}
