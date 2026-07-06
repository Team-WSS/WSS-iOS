//
//  DetailSearchInfoPlatformCollectionViewCell.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 7/6/26.
//

import UIKit

import SnapKit
import Then

final class DetailSearchInfoPlatformCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    override var isSelected: Bool {
        didSet {
            self.platformKeywordView.updateColor(isSelected)
        }
    }
    
    //MARK: - Components
    
    private let platformKeywordView = KeywordLink()
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI
    
    private func setHierarchy() {
        self.addSubview(platformKeywordView)
    }
    
    private func setLayout() {
        platformKeywordView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    //MARK: - Data
    
    func bindData(platform: String) {
        platformKeywordView.do {
            $0.setText(platform)
        }
    }
}

