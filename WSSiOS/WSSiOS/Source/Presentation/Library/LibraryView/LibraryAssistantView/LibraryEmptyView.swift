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
    
    //MARK: - UI Components
    
    private let emptyStackView = UIStackView()
    private let emptyImageView = UIImageView()
    private let emptyTitleLabel = UILabel()
    public let libraryRegisterButton = UIButton()
    
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
        self.backgroundColor = .White
        
        emptyStackView.do {
            $0.axis = .vertical
            $0.distribution = .fill
            $0.alignment = .center
            $0.spacing = 8
            
            emptyImageView.do {
                $0.image = ImageLiterals.icon.Library.register
            }
            
            emptyTitleLabel.do {
                $0.text = StringLiterals.Library.empty
                $0.makeAttribute(with: StringLiterals.Library.empty)?
                    .kerning(kerningPixel: -0.8)
                    .applyAttribute()
                $0.font = .Body1
                $0.textColor = .Gray200
                $0.textAlignment = .center
            }
        }
        
        libraryRegisterButton.do {
            $0.setTitle(StringLiterals.Library.register, for: .normal)
            $0.setTitleColor(.Primary100, for: .normal)
            $0.titleLabel?.font = .Title1
            $0.layer.backgroundColor = UIColor.Primary50.cgColor
            $0.layer.cornerRadius = 12
        }
    }
    
    //MARK: - set Hierachy
    
    private func setHierachy() {
        self.addSubviews(emptyStackView,
                         libraryRegisterButton)
        emptyStackView.addArrangedSubviews(emptyImageView,
                                           emptyTitleLabel)
    }
    
    //MARK: - set Layout
    
    private func setLayout() {
        emptyStackView.snp.makeConstraints() {
            $0.top.equalToSuperview().inset(129)
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().inset(90)
        }
        
        emptyImageView.snp.makeConstraints() {
            $0.size.equalTo(48)
        }
        
        libraryRegisterButton.snp.makeConstraints() {
            $0.top.equalTo(emptyStackView.snp.bottom).offset(45)
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().inset(90)
            $0.height.equalTo(53)
        }
    }
}
