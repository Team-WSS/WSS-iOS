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
    lazy var libraryNovelListButtonLabel = UILabel()
    private var libraryNovelListButtonImageView = UIImageView()
    
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
            $0.textColor = .wssGray200
        }
        
        libraryNovelListButton.do {
            $0.backgroundColor = .clear
        }
        
        libraryNovelListButtonLabel.do {
            $0.applyWSSFont(.body4, with: StringLiterals.Alignment.newest.title)
            $0.textColor = .wssGray300
            $0.isUserInteractionEnabled = false
        }
        
        libraryNovelListButtonImageView.do {
            $0.image = .icDropDown
            $0.isUserInteractionEnabled = false
        }
    }

    private func setHierarchy() {
        self.addSubviews(libraryNovelCountLabel,
                         libraryNovelListButton)
        libraryNovelListButton.addSubviews(libraryNovelListButtonImageView,
                                           libraryNovelListButtonLabel)
    }
    
    private func setLayout() {
        libraryNovelCountLabel.snp.makeConstraints() {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
        
        libraryNovelListButton.snp.makeConstraints() {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
            
            libraryNovelListButtonImageView.snp.makeConstraints {
                $0.top.bottom.trailing.equalToSuperview()
                $0.size.equalTo(20)
            }
            
            libraryNovelListButtonLabel.snp.makeConstraints {
                $0.centerY.equalTo(libraryNovelListButtonImageView.snp.centerY)
                $0.trailing.equalTo(libraryNovelListButtonImageView.snp.leading).offset(-8)
            }
        }
    }
    
    func updateNovelCount(count: Int) {
        let text = String(describing: count) + "개"
        libraryNovelCountLabel.applyWSSFont(.body4, with: text)
    }
    
    func updatelibraryNovelListButtonTitle(title: Bool) {
        libraryNovelListButtonLabel.applyWSSFont(.body4, with: title ? StringLiterals.Library.newest : StringLiterals.Library.oldest)
    }
}
