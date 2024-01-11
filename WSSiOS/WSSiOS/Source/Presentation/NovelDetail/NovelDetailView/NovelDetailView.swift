//
//  NovelDetailView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 1/11/24.
//

import UIKit

import SnapKit
import Then

final class NovelDetailView: UIView {
    
    // MARK: - UI Components

    let scrollView = UIScrollView()
    let contentView = UIStackView()
    let novelDetailHeaderView = NovelDetailHeaderView()
    let novelDetailTabView = NovelDetailTabView()
    let novelDetailMemoView = NovelDetailMemoView()

    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierachy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - set UI
    
    private func setUI() {
        self.backgroundColor = .White
        
        scrollView.do {
            $0.contentInsetAdjustmentBehavior = .never
            $0.showsVerticalScrollIndicator = false
        }
        
        contentView.do {
            $0.alignment = .fill
            $0.axis = .vertical
        }
    }
    
    // MARK: - set Hierachy
    
    private func setHierachy() {
        self.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addArrangedSubviews(novelDetailHeaderView,
                                        novelDetailTabView,
                                        novelDetailMemoView)
    }
    
    // MARK: - set Layout
    
    private func setLayout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalToSuperview()
        }
    }
}
