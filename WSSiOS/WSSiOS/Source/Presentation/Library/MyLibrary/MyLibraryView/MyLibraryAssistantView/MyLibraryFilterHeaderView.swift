//
//  MyLibraryFilterHeaderView.swift
//  WSSiOS
//
//  Created by YunhakLee on 6/25/25.
//


import UIKit

import SnapKit
import Then

final class MyLibraryFilterHeaderView: UIView {
    
    //MARK: - Components
    
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    let interestFilterButton = WSSFilterButton()
    private let dividerView = UIView()
    let readStatusFilterButton = WSSFilterButton()
    let starRatingFilterButton = WSSFilterButton()
    let attractivePointFilterButton = WSSFilterButton()
    
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
        
        scrollView.do {
            $0.showsVerticalScrollIndicator = false
            $0.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
        
        stackView.do {
            $0.axis = .horizontal
            $0.alignment = .center
        }
        
        interestFilterButton.do {
            $0.setImageHidden(isHidden: true)
            $0.setButtonText(StringLiterals.MyLibrary.FilterButton.interest)
        }
        
        dividerView.do {
            $0.backgroundColor = .wssGray80
        }
        
        readStatusFilterButton.do {
            $0.setImageHidden(isHidden: false)
            $0.setButtonText(StringLiterals.MyLibrary.FilterButton.readStatus)
        }
        
        starRatingFilterButton.do {
            $0.setImageHidden(isHidden: false)
            $0.setButtonText(StringLiterals.MyLibrary.FilterButton.starRating)
        }
        
        attractivePointFilterButton.do {
            $0.setImageHidden(isHidden: false)
            $0.setButtonText(StringLiterals.MyLibrary.FilterButton.attractivePoint)
        }
    }
    
    private func setHierarchy() {
        self.addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubviews(interestFilterButton,
                                      dividerView,
                                      readStatusFilterButton,
                                      starRatingFilterButton,
                                      attractivePointFilterButton)
    }
    
    private func setLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(57)
        }
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalToSuperview()
        }
        
        stackView.do {
            $0.spacing = 6
            $0.setCustomSpacing(10, after: interestFilterButton)
            $0.setCustomSpacing(10, after: dividerView)
        }
        
        dividerView.snp.makeConstraints {
            $0.height.equalTo(33)
            $0.width.equalTo(1)
        }
    }
    
    func updateFilterButtons(selectedOption: LibraryFilterOption) {
        interestFilterButton.updateButton(isSelected: selectedOption.interestedOption)
        updateReadStatusFilterButton(selectedOption: selectedOption.readStatusOptions)
        updateStarRatingFilterButton(selectedOption: selectedOption.starRatingOption)
        updateAttractivePointFilterButton(selectedOption: selectedOption.attractivePointOptions)
    }
    
    private func updateReadStatusFilterButton(selectedOption: [ReadStatus]) {
        let isSelected = !selectedOption.isEmpty
        let isMoreThanOne = selectedOption.count > 1
        let overCount = selectedOption.count - 1
        
        let text = switch (isSelected, isMoreThanOne) {
        case (true, false): selectedOption.first?.minimalStatusName
        case (true, true): "\(selectedOption.first?.minimalStatusName ?? "") 외\(overCount)"
        case (false, _): StringLiterals.MyLibrary.FilterButton.readStatus
        }
        
        readStatusFilterButton.do {
            $0.setButtonText(text)
            $0.updateButton(isSelected: isSelected)
        }
    }
    
    private func updateStarRatingFilterButton(selectedOption: NovelRatingStatus?) {
        let isSelected = selectedOption != nil
        let text = isSelected ? selectedOption?.description : StringLiterals.MyLibrary.FilterButton.starRating
        
        starRatingFilterButton.do {
            $0.setButtonText(text)
            $0.updateButton(isSelected: isSelected)
        }
    }
    
    private func updateAttractivePointFilterButton(selectedOption: [AttractivePoint]) {
        let isSelected = !selectedOption.isEmpty
        let isMoreThanOne = selectedOption.count > 1
        let overCount = selectedOption.count - 1
        
        let text = switch (isSelected, isMoreThanOne) {
        case (true, false): selectedOption.first?.koreanString
        case (true, true): "\(selectedOption.first?.koreanString ?? "") 외\(overCount)"
        case (false, _): StringLiterals.MyLibrary.FilterButton.attractivePoint
        }
        
        attractivePointFilterButton.do {
            $0.setButtonText(text)
            $0.updateButton(isSelected: isSelected)
        }
    }
}

