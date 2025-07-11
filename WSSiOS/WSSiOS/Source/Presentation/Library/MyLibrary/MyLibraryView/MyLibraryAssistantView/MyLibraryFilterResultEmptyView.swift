//
//  MyLibraryFilterResultEmptyView.swift
//  WSSiOS
//
//  Created by YunhakLee on 6/25/25.
//

import UIKit

import SnapKit
import Then

final class MyLibraryFilterResultEmptyView: UIView {
    
    //MARK: - Components
    
    private let stackView = UIStackView()
    private let imageView = UIImageView()
    private let descriptionLabel = UILabel()
    
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
            $0.applyWSSFont(.body1, with: StringLiterals.MyLibrary.Empty.filterResultEmpty)
            $0.textColor = .wssGray200
            $0.textAlignment = .center
            $0.numberOfLines = 2
        }
    }

    private func setHierarchy() {
        self.addSubviews(stackView)
        stackView.addArrangedSubviews(imageView,
                                      descriptionLabel)
    }
    
    private func setLayout() {
        stackView.snp.makeConstraints() {
            $0.centerY.equalToSuperview().offset(-47)
            $0.horizontalEdges.equalToSuperview()
        }
        
        stackView.do {
            $0.spacing = 8
        }
        
        imageView.snp.makeConstraints() {
            $0.height.equalTo(48)
        }
    }
}
