//
//  NovelDetailView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 1/11/24.
//

import UIKit

import SnapKit

final class NovelDetailView: UIView {
    
    // MARK: - UI Components

    let scrollView = UIScrollView()
    let contentView = UIView()
    let novelDetailHeaderView = NovelDetailHeaderView()
    let novelDetailTabView = NovelDetailTabView()

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
    }
    
    // MARK: - set Hierachy
    
    private func setHierachy() {
        self.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(novelDetailHeaderView, 
                                novelDetailTabView)
    }
    
    // MARK: - set Layout
    
    private func setLayout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.width.equalToSuperview()
        }
        
        novelDetailHeaderView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(302)
        }
        
        novelDetailTabView.snp.makeConstraints {
            $0.top.equalTo(novelDetailHeaderView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
    }
}
