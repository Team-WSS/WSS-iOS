//
//  MyPageEditProfileGenreCollectionViewCell.swift
//  WSSiOS
//
//  Created by 신지원 on 7/26/24.
//

import UIKit

import SnapKit
import Then

final class MyPageEditProfileGenreCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Life Cycle
    
    private let genreKeywordLink = KeywordLink()
    
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
        self.addSubview(genreKeywordLink)
    }
    
    private func setLayout() {
        genreKeywordLink.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(37)
        }
    }
    
    //MARK: - Data
    
    func bindData(genre: String) {
        genreKeywordLink.setText(genre)
    }
    
    func updateCell(isSelected: Bool) {
        genreKeywordLink.updateColor(isSelected)
    }
}
