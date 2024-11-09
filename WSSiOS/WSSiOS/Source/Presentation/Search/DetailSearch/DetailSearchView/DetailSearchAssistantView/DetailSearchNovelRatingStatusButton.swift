//
//  DetailSearchNovelRatingStatusButton.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 10/23/24.
//

import UIKit

import SnapKit
import Then

final class DetailSearchNovelRatingStatusButton: UIButton {
    
    //MARK: - Properties
    
    let status: NovelRatingStatus

    //MARK: - Components

    private let buttonLabel = UILabel()
    
    //MARK: - Life Cycle
    
    init(status: NovelRatingStatus) {
        self.status = status
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
            $0.backgroundColor = .wssGray50
            $0.layer.borderColor = UIColor.wssPrimary100.cgColor
            $0.layer.cornerRadius = 8
        }
        
        buttonLabel.do {
            $0.applyWSSFont(.body2, with: status.description)
            $0.textColor = .wssGray300
            $0.isUserInteractionEnabled = false
        }
    }
    
    private func setHierarchy() {
        self.addSubview(buttonLabel)
    }
    
    private func setLayout() {
        buttonLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    // MARK: - Custom Method
    
    func updateButton(selectedNovelRatingStatus: NovelRatingStatus?) {
        let isSelected = selectedNovelRatingStatus == status
        
        self.do {
            $0.backgroundColor = isSelected ? .wssPrimary50 : .wssGray50
            $0.layer.borderWidth = isSelected ? 1 : 0
        }
        
        buttonLabel.do {
            $0.textColor = isSelected ? .wssPrimary100 : .wssGray300
        }
    }
}

