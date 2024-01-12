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

    // MARK: - UI Components
    
    let contentView = UIStackView()
    let novelDetailInfoRatingView = NovelDetailInfoRatingView()
    let novelDetailInfoReadStatusView = NovelDetailInfoReadStatusView()
    let novelDetailInfoReadDateView = NovelDetailInfoReadDateView()

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
        contentView.do {
            $0.alignment = .fill
            $0.axis = .vertical
        }
    }
    
    // MARK: - set Hierachy
    
    private func setHierachy() {
        self.addSubview(contentView)
        contentView.addArrangedSubviews(novelDetailInfoRatingView,
                                        novelDetailInfoReadStatusView,
                                        novelDetailInfoReadDateView)
    }
    
    // MARK: - set Layout
    
    private func setLayout() {
        contentView.snp.makeConstraints {
            $0.edges.width.equalToSuperview()
        }
    }
}
