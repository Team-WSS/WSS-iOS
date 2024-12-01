//
//  LibraryEmptyView.swift
//  WSSiOS
//
//  Created by 신지원 on 1/18/24.
//

import UIKit

import SnapKit
import Then

final class LibraryEmptyView: UIView {
    
    //MARK: - Components
    
    private let emptyStackView = UIStackView()
    private let emptyImageView = UIImageView()
    private let emptyTitleLabel = UILabel()
    var libraryLookForNovelButton = UIButton()
    private var libraryLookForNovelButtonLabel = UILabel()
    
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
        self.backgroundColor = .wssWhite
        
        emptyStackView.do {
            $0.axis = .vertical
            $0.distribution = .fill
            $0.alignment = .center
            $0.spacing = 8
            
            emptyImageView.do {
                $0.image = .icGenreDefault
            }
            
            emptyTitleLabel.do {
                $0.applyWSSFont(.body1, with: StringLiterals.Library.empty)
                $0.textColor = .wssGray200
                $0.textAlignment = .center
            }
        }
        
        libraryLookForNovelButton.do {
            $0.layer.backgroundColor = UIColor.wssPrimary50.cgColor
            $0.layer.cornerRadius = 12
        }
        
        libraryLookForNovelButtonLabel.do {
            $0.applyWSSFont(.title1, with: StringLiterals.Library.lookForNovel)
            $0.textColor = .wssPrimary100
            $0.isUserInteractionEnabled = true
        }
    }

    private func setHierarchy() {
        self.addSubviews(emptyStackView,
                         libraryLookForNovelButton)
        emptyStackView.addArrangedSubviews(emptyImageView,
                                           emptyTitleLabel)
        libraryLookForNovelButton.addSubview(libraryLookForNovelButtonLabel)
    }
    
    private func setLayout() {
        emptyStackView.snp.makeConstraints() {
            $0.top.equalToSuperview().inset(129)
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().inset(90)
        }
        
        emptyImageView.snp.makeConstraints() {
            $0.height.equalTo(48)
        }
        
        libraryLookForNovelButton.snp.makeConstraints() {
            $0.top.equalTo(emptyStackView.snp.bottom).offset(45)
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().inset(90)
            $0.height.equalTo(53)
            
            libraryLookForNovelButtonLabel.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
        }
    }
}
