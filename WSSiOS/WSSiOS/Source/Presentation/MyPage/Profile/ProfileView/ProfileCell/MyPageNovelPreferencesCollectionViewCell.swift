//
//  MyPageNovelPreferencesCollectionViewCell.swift
//  WSSiOS
//
//  Created by 신지원 on 11/16/24.
//

import UIKit

import SnapKit
import Then

final class MyPageNovelPreferencesCollectionViewCell: UICollectionViewCell {
    
    //MARK: - UI Components
    
    private let keywordLabel = KeywordLabel()
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setHierarchy()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI
    
    private func setHierarchy() {
        self.addSubview(keywordLabel)
    }
    
    private func setLayout() {
        keywordLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func bindData(data: Keyword) {
        print("😄", data)
        keywordLabel.setText("\(data.keywordName) \(data.keywordCount)")
    }
}
