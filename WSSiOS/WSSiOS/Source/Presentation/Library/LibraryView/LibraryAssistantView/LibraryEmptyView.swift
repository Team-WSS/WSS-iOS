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
    lazy var libraryLookForNovelButton = UIButton()
    
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
                $0.image = .register
            }
            
            emptyTitleLabel.do {
                $0.text = StringLiterals.Library.empty
                $0.makeAttribute(with: StringLiterals.Library.empty)?
                    .kerning(kerningPixel: -0.8)
                    .applyAttribute()
                $0.font = .Body1
                $0.textColor = .wssGray200
                $0.textAlignment = .center
            }
        }
        
        libraryLookForNovelButton.do {
            $0.setTitle(StringLiterals.Library.lookForNovel, for: .normal)
            $0.setTitleColor(.wssPrimary100, for: .normal)
            $0.titleLabel?.font = .Title1
            $0.layer.backgroundColor = UIColor.wssPrimary50.cgColor
            $0.layer.cornerRadius = 12
        }
        
        backButton.snp.makeConstraints {
            $0.size.equalTo(44)
        }
    }

    private func setHierarchy() {
        self.addSubviews(emptyStackView,
                         libraryLookForNovelButton)
        emptyStackView.addArrangedSubviews(emptyImageView,
                                           emptyTitleLabel)
    }
    
    private func setLayout() {
        emptyStackView.snp.makeConstraints() {
            $0.top.equalToSuperview().inset(129)
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().inset(90)
        }
        
        emptyImageView.snp.makeConstraints() {
            $0.size.equalTo(48)
        }
        
        libraryLookForNovelButton.snp.makeConstraints() {
            $0.top.equalTo(emptyStackView.snp.bottom).offset(45)
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().inset(90)
            $0.height.equalTo(53)
        }
    }
}
