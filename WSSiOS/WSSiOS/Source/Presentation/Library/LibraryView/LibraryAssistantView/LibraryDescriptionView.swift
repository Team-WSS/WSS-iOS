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

    //MARK: - UI Components
    
    public let libraryNovelCountLabel = UILabel()
    public lazy var libraryNovelListButton = UIButton()
    
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
    
    //MARK: - set UI
    
    private func setUI() {
        self.backgroundColor = .Gray50
        
        libraryNovelCountLabel.do {
            $0.font = .Label1
            $0.textColor = .Gray200
        }
        
        libraryNovelListButton.do {
            let title = StringLiterals.Library.newest
            var attString = AttributedString(title)
            attString.font = UIFont.Label1
//            attString.foregroundColor = UIColor.Gray300
            
            var configuration = UIButton.Configuration.filled()
            configuration.attributedTitle = attString
            configuration.image = ImageLiterals.icon.dropDown
            configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 0)
            configuration.imagePlacement = .trailing
            configuration.baseBackgroundColor = UIColor.clear
            $0.configuration = configuration
        }
    }
    
    //MARK: - set Hierachy
    
    private func setHierachy() {
        self.addSubviews(libraryNovelCountLabel,
                         libraryNovelListButton)
    }
    
    //MARK: - set Layout
    
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
