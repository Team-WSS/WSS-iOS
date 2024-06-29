//
//  FeedNovelConnectView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 6/29/24.
//

import UIKit

import SnapKit
import Then

final class FeedNovelConnectView: UIView {
    
    //MARK: - Components
    
    private let novelConnectLabel = UILabel()
    private let novelSearchView = UIView()
    private let novelSearchLabel = UILabel()
    private let searchImageView = UIImageView()
    
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
        
        novelConnectLabel.do {
            $0.applyWSSFont(.title2, with: "작품 연결하기")
            $0.textColor = .wssBlack
        }
        
        novelSearchView.do {
            $0.backgroundColor = .wssGray50
            $0.layer.cornerRadius = 14
        }
        
        novelSearchLabel.do {
            $0.applyWSSFont(.label1, with: "작품 제목, 작가를 검색하세요")
            $0.textColor = .wssGray200
        }
        
        searchImageView.do {
            $0.image = .icSearch.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .wssGray300
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(novelConnectLabel,
                         novelSearchView)
        novelSearchView.addSubviews(novelSearchLabel,
                                    searchImageView)
    }
    
    private func setLayout() {
        novelConnectLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
        }
        
        novelSearchView.snp.makeConstraints {
            $0.top.equalTo(novelConnectLabel.snp.bottom).offset(17)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(42)
        }
        
        novelSearchLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
        }
        
        searchImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(15)
        }
    }
}
