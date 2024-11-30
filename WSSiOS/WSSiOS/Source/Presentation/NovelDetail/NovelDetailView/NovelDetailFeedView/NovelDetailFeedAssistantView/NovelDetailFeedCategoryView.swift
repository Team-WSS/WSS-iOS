//
//  NovelDetailFeedCategoryView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 9/27/24.
//

import UIKit

import SnapKit
import Then

final class NovelDetailFeedCategoryView: UIView {

    //MARK: - Components
    
    private let categoryLabel = UILabel()
    
    // MARK: - Life Cycle
    
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
        categoryLabel.do {
            $0.textColor = .wssGray200
            $0.numberOfLines = 0
            $0.lineBreakMode = .byWordWrapping
            $0.lineBreakStrategy = .hangulWordPriority
        }
    }
    
    private func setHierarchy() {
        self.addSubview(categoryLabel)
    }
    
    private func setLayout() {
        categoryLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(4)
        }
    }
    
    //MARK: - Data
    
    func bindData(relevantCategories: [String]) {
        categoryLabel.applyWSSFont(.body2, with: relevantCategories.joined(separator: ", "))
    }
}
