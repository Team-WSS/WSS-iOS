//
//  NovelDetailHeaderReadStatusButton.swift
//  WSSiOS
//
//  Created by YunhakLee on 8/20/24.
//

import UIKit

import SnapKit
import Then

final class NovelDetailHeaderReadStatusButton: UIButton {
    
    //MARK: - Properties
    
    let readStatus: ReadStatus
    
    //MARK: - Components
    
    private let stackView = UIStackView()
    private let statusImageView = UIImageView()
    private let statusLabel = UILabel()
    
    //MARK: - Life Cycle
    
    init(readStatus: ReadStatus) {
        self.readStatus = readStatus
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
        stackView.do {
            $0.axis = .vertical
            $0.alignment =  .center
            
            statusImageView.do {
                $0.image = readStatus.strokeImage
            }
            
            statusLabel.do {
                $0.applyWSSFont(.body4, with: readStatus.text)
            }
        }
    }
    
    private func setHierarchy() {
        self.addSubview(stackView)
        
        stackView.addArrangedSubviews(statusImageView,
                                      statusLabel)
    }
    
    private func setLayout() {
        stackView.do {
            $0.snp.makeConstraints {
                $0.verticalEdges.equalToSuperview().inset(5)
                $0.horizontalEdges.equalToSuperview()
            }
            
            $0.spacing = 5
        }
    }
    
    //MARK: - Data
    
    func updateButton(selectedStatus: ReadStatus?) {
        if selectedStatus == readStatus {
            updateHilightedStyle()
        } else {
            updateNormalStyle()
        }
    }
    
    //MARK: - Custom Method
    
    private func updateNormalStyle() {
        statusImageView.image = readStatus.strokeImage
        statusLabel.textColor = .wssGray300
    }
    
    private func updateHilightedStyle() {
        statusImageView.image = readStatus.fillImage
        statusLabel.textColor = .wssSecondary100
    }
}
