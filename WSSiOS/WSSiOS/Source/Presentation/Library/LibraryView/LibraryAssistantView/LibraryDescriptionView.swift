//
//  LibraryDescriptionView.swift
//  WSSiOS
//
//  Created by 신지원 on 1/15/24.
//

import UIKit

import SnapKit
import Then

final class LibraryDescriptionView: UIView {
    
    //MARK: - Components
    
    let libraryNovelCountLabel = UILabel()
    lazy var libraryNovelListButton = UIButton()
    
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
        self.backgroundColor = .wssGray50
        
        libraryNovelCountLabel.do {
            $0.font = .Label1
            $0.textColor = .wssGray200
        }
        
        libraryNovelListButton.do {
            let title = StringLiterals.Alignment.newest.title
            var attString = AttributedString(title)
            attString.font = UIFont.Label1
            attString.foregroundColor = UIColor.wssGray300
            
            var configuration = UIButton.Configuration.filled()
            configuration.attributedTitle = attString
            configuration.image = .icDropDown
            configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 0)
            configuration.imagePlacement = .trailing
            configuration.baseBackgroundColor = UIColor.clear
            $0.configuration = configuration
        }
    }

    private func setHierarchy() {
        self.addSubviews(libraryNovelCountLabel,
                         libraryNovelListButton)
    }
    
    private func setLayout() {
        libraryNovelCountLabel.snp.makeConstraints() {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
        
        libraryNovelListButton.snp.makeConstraints() {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
        }
    }
}
