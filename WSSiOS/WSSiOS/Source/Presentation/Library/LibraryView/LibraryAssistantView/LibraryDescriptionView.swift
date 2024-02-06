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
    
    public var libraryNovelCountLabel = UILabel()
    public var libraryNovelListButton = UIButton()
    
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
    
    //MARK: - set UI
    
    private func setUI() {
        self.backgroundColor = .Gray50
        
        libraryNovelCountLabel.do {
            $0.font = .Label1
            $0.textColor = .Gray200
        }
        
        libraryNovelListButton.do {
            $0.setTitle("최신 순", for: .normal)
            $0.setTitleColor(.Gray300, for: .normal)
            $00.titleLabel?.font = .Label1
            $0.titleLabel?.adjustsFontSizeToFitWidth = true
            $0.setImage(ImageLiterals.icon.dropDown, for: .normal)
            $0.semanticContentAttribute = .forceRightToLeft
            $0.imageEdgeInsets = .init(top: 0, left: 8, bottom: 0, right: 0)
        }
    }
    
    //MARK: - set Hierachy
    
    private func setHierarchy() {
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
