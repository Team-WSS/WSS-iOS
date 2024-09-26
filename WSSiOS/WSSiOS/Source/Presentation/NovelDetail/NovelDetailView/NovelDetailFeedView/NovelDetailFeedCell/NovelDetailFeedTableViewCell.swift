//
//  NovelDetailFeedTableViewCell.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 9/27/24.
//

import UIKit

import SnapKit
import Then

final class NovelDetailFeedTableViewCell: UITableViewCell {
    
    //MARK: - Components
    
    private let stackView = UIStackView()
    let novelDetailFeedHeaderView = NovelDetailFeedHeaderView()
    
    //MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
            $0.selectionStyle = .none
        }
        
        stackView.do {
            $0.axis = .vertical
            $0.distribution = .fill
            $0.alignment = .fill
        }
    }
    
    private func setHierarchy() {
        self.addSubview(stackView)
        stackView.addArrangedSubviews(novelDetailFeedHeaderView)
    }
    
    private func setLayout() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(20)
            
            stackView.do {
                $0.setCustomSpacing(12, after: novelDetailFeedHeaderView)
            }
        }
    }
    
    //MARK: - Data
    
    func bindData(feed: TotalFeeds) {
        novelDetailFeedHeaderView.bindData(avatarImage: feed.avatarImage,
                                           nickname: feed.nickname,
                                           createdDate: feed.createdDate,
                                           isModified: feed.isModified)
    }
}
