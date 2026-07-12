//
//  LibraryFilterChipCell.swift
//  WSSiOS
//
//  Created by YunhakLee on 6/21/26.
//

import UIKit

import SnapKit
import Then

final class LibraryFilterChipCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    static let identifier = "LibraryFilterChipCell"
    
    //MARK: - UI Components
    
    private let chipLink = KeywordLink()
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        self.do {
            $0.backgroundColor = .clear
        }
    }
    
    private func setHierarchy() {
        contentView.addSubview(chipLink)
    }
    
    private func setLayout() {
        chipLink.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    //MARK: - Custom Method
    
    func configure(title: String, isSelected: Bool) {
        chipLink.setText(title)
        chipLink.updateColor(isSelected)
    }
}
