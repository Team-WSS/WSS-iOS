//
//  MyLibraryEmptyView.swift
//  WSSiOS
//
//  Created by YunhakLee on 6/25/25.
//

import UIKit

import SnapKit
import Then

final class MyLibraryEmptyView: UIView {
    
    //MARK: - Components
    
    private let stackView = UIStackView()
    private let imageView = UIImageView()
    private let descriptionLabel = UILabel()
    var searchNovelButton = UIButton()
    private var searchNovelButtonLabel = UILabel()
    
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
        
        stackView.do {
            $0.axis = .vertical
            $0.alignment = .center
        }
        
        imageView.do {
            $0.image = .imgEmpty
        }
        
        descriptionLabel.do {
            $0.applyWSSFont(.body1, with: StringLiterals.Library.empty)
            $0.textColor = .wssGray200
        }
        
        searchNovelButton.do {
            $0.layer.backgroundColor = UIColor.wssPrimary50.cgColor
            $0.layer.cornerRadius = 12
        }
        
        searchNovelButtonLabel.do {
            $0.applyWSSFont(.title1, with: StringLiterals.Library.lookForNovel)
            $0.textColor = .wssPrimary100
            $0.isUserInteractionEnabled = false
        }
    }

    private func setHierarchy() {
        self.addSubviews(stackView)
        stackView.addArrangedSubviews(imageView,
                                      descriptionLabel,
                                      searchNovelButton)
        searchNovelButton.addSubview(searchNovelButtonLabel)
    }
    
    private func setLayout() {
        stackView.snp.makeConstraints() {
            $0.centerY.equalToSuperview().offset(-59)
            $0.horizontalEdges.equalToSuperview()
        }
        
        stackView.do {
            $0.setCustomSpacing(8, after: imageView)
            $0.setCustomSpacing(45, after: descriptionLabel)
        }
        
        imageView.snp.makeConstraints() {
            $0.height.equalTo(48)
        }
        
        searchNovelButton.snp.makeConstraints() {
            $0.height.equalTo(53)
            $0.horizontalEdges.equalToSuperview().inset(90)
        }
        
        searchNovelButtonLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
