//
//  LibraryFilterAttractivePointOptionButton.swift
//  WSSiOS
//
//  Created by YunhakLee on 6/26/25.
//

import UIKit

import SnapKit
import Then

final class LibraryFilterAttractivePointOptionButton: UIButton {
    
    //MARK: - Properties
    
    let attractivePoint: AttractivePoint
    
    //MARK: - UI Components
    
    private let stackView = UIStackView()
    private let statusImage = UIImageView()
    private let statusLabel = UILabel()
    
    //MARK: - Life Cycle
    
    init(_ attractivePoint: AttractivePoint) {
        self.attractivePoint = attractivePoint
        
        super.init(frame: .zero)
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        stackView.do {
            $0.axis = .vertical
            $0.spacing = 6
            $0.alignment = .center
            $0.isUserInteractionEnabled = false
        }
        
        statusLabel.do {
            $0.applyWSSFont(.body4, with: attractivePoint.koreanString)
            $0.textColor = .wssGray300
            $0.isUserInteractionEnabled = false
        }
        
        statusImage.do {
            $0.image = attractivePoint.image.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .wssGray100
            $0.contentMode = .scaleAspectFit
            $0.isUserInteractionEnabled = false
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(stackView)
        stackView.addArrangedSubviews(statusImage,
                                      statusLabel)
    }
    
    private func setLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(68)
        }
        
        stackView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
        }
        
        statusImage.snp.makeConstraints {
            $0.size.equalTo(36)
        }
    }
}
