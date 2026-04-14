//
//  NovelReviewAttractivePointView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 9/13/24.
//

import UIKit

import SnapKit
import Then

final class NovelReviewAttractivePointView: UIView {
    
    //MARK: - Components
    
    private let titleLabel = UILabel()
    let stackView = UIStackView()
    let attractivePointOptionButtons = AttractivePoint.allCases.map {
        LibraryFilterAttractivePointOptionButton($0)
    }
    
    //MARK: - Life Cycle
    
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
        self.do {
            $0.backgroundColor = .wssWhite
        }
        
        titleLabel.do {
            $0.applyWSSFont(.title3, with: StringLiterals.NovelReview.AttractivePoint.attractivePoint)
            $0.textColor = .wssBlack
        }
        
        stackView.do {
            $0.axis = .horizontal
            $0.spacing = 0
            $0.distribution = .fillEqually
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(titleLabel, 
                         stackView)
        
        attractivePointOptionButtons.forEach {
            stackView.addArrangedSubview($0)
        }
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(25)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(14)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(25)
        }
    }
    
    //MARK: - Custom Method
    
    func updateButtons(selectedOptions: [AttractivePoint]) {
        attractivePointOptionButtons.forEach {
            $0.updateButton(selectedOptions: selectedOptions)
        }
    }
}
