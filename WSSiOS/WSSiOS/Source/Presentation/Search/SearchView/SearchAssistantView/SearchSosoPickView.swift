//
//  SearchSosoPickView.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/26/24.
//

import UIKit

import SnapKit
import Then

final class SearchSosoPickView: UIView {
    
    //MARK: - Components
    
    private let titleLabel = UILabel()
    private let pickImageView = UIImageView()
    private let descriptionLabel = UILabel()
    private let testView = SosoPickCollectionViewCell()
    let sosopickCollectionView = UICollectionView(frame: .zero,
                                                  collectionViewLayout: UICollectionViewLayout())
    private let sosopickCollectionViewLayout = UICollectionViewFlowLayout()
    
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
    
    //MARK: - UI
    
    private func setUI() {
        titleLabel.do {
            $0.fontTitle1Attribute(with: StringLiterals.Search.sosoTitle)
            $0.textColor = .wssBlack
        }
        
        pickImageView.do {
            $0.image = .icTextPick
        }
        
        descriptionLabel.do {
            $0.fontLabel1Attribute(with: StringLiterals.Search.sosoDescription)
            $0.textColor = .wssGray200
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(titleLabel,
                         pickImageView,
                         descriptionLabel,
                         testView)
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        pickImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(2.5)
            $0.leading.equalTo(titleLabel.snp.trailing).offset(2)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.leading.equalTo(titleLabel.snp.leading)
        }
        
        testView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(12)
            $0.leading.equalTo(titleLabel.snp.leading)
        }
    }
}
