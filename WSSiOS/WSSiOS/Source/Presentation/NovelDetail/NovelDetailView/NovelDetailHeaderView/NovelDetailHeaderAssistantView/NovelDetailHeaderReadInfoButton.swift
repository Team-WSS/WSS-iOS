//
//  NovelDetailHeaderReadInfoButton.swift
//  WSSiOS
//
//  Created by YunhakLee on 8/20/24.
//

import UIKit

import SnapKit
import Then

final class NovelDetailHeaderReadInfoButton: UIButton {
    
    //MARK: - Properties
    
    let height: CGFloat = 23
    let iconImage: UIImage
    
    //MARK: - Components
    
    private let stackView = UIStackView()
    private let iconImageView = UIImageView()
    private let readInfoLabel = UILabel()
    private let navigationImageView = UIImageView()
    
    //MARK: - Life Cycle
    
    init(iconImage: UIImage) {
        self.iconImage = iconImage
        
        super.init(frame: .zero)
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI
    
    private func setUI() {
        self.do {
            $0.backgroundColor = .wssWhite
            $0.layer.cornerRadius = height/2
            $0.layer.borderColor = UIColor.wssGray80.cgColor
            $0.layer.borderWidth = 1
        }
        
        stackView.do {
            $0.axis = .horizontal
            $0.alignment = .center
            
            iconImageView.image = iconImage
            
            navigationImageView.image = .icChveronRightMini
        }
    }
    
    private func setHierarchy() {
        self.addSubview(stackView)
        stackView.addArrangedSubviews(iconImageView,
                                      readInfoLabel,
                                      navigationImageView)
    }
    
    private func setLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(height)
        }
        stackView.do {
            $0.snp.makeConstraints {
                $0.verticalEdges.equalToSuperview().inset(3)
                $0.leading.equalToSuperview().inset(12)
                $0.trailing.equalToSuperview().inset(10)
            }
            
            $0.spacing = 5
        }
    }
    
    //MARK: - Data
    
    func bindData(infoText: String) {
        readInfoLabel.do {
            $0.applyWSSFont(.body5, with: infoText)
            $0.textColor = .wssGray300
        }
    }
}
