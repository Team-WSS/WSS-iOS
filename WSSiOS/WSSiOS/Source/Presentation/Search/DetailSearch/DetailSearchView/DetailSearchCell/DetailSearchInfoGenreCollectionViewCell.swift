//
//  DetailSearchInfoGenreCollectionViewCell.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 7/18/24.
//

import UIKit

import SnapKit
import Then

final class DetailSearchInfoGenreCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    override var isSelected: Bool {
        didSet {
            self.genreKeywordView.updateColor(isSelected)
        }
    }
    
    //MARK: - Components
    
    private let genreKeywordView = KeywordLink()
    
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
        self.addSubview(genreKeywordView)
    }
    
    private func setLayout() {
        genreKeywordView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(35)
        }
    }

    //MARK: - Data
    
    func bindData(genre: String) {
        genreKeywordView.do {
            $0.setText(genre)
        }
    }
}

