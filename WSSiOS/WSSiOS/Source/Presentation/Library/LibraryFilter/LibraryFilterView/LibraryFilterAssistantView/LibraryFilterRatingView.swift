//
//  LibraryFilterRatingView.swift
//  WSSiOS
//
//  Created by YunhakLee on 5/26/25.
//

import UIKit

import SnapKit
import Then

final class LibraryFilterRatingView: UIView {
    
    //MARK: - UI Components
    
    private let titleLabel = UILabel()
    private let ratingTopStackView = UIStackView()
    private let ratingBottomStackView = UIStackView()
    
    let novelRatingStatusButtons = NovelRatingStatus.allCases.map { WSSNovelRatingStatusButton(status: $0) }
    
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
    
    private func setUI() {
        titleLabel.do {
            $0.applyWSSFont(.title2, with: StringLiterals.MyLibrary.Filter.rating)
            $0.textColor = .wssBlack
        }
        
        ratingTopStackView.do {
            $0.axis = .horizontal
            $0.spacing = 11
            $0.distribution = .fillEqually
        }
        
        ratingBottomStackView.do {
            $0.axis = .horizontal
            $0.spacing = 11
            $0.distribution = .fillEqually
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(titleLabel,
                         ratingTopStackView,
                         ratingBottomStackView)
        
        let topRowButtons = Array(novelRatingStatusButtons.prefix(2))
        let bottomRowButtons = Array(novelRatingStatusButtons.suffix(2))
        
        topRowButtons.forEach { ratingTopStackView.addArrangedSubview($0) }
        bottomRowButtons.forEach { ratingBottomStackView.addArrangedSubview($0) }
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().inset(20)
        }
        
        ratingTopStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        ratingBottomStackView.snp.makeConstraints {
            $0.top.equalTo(ratingTopStackView.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
        }
    }
    
    //MARK: - Custom Method
    
    func updateButtons(selectedOption: NovelRatingStatus?) {
        novelRatingStatusButtons.forEach {
            $0.updateButton(selectedNovelRatingStatus: selectedOption)
        }
    }
}
