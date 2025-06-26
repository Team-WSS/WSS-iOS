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
    
    let scrollView = UIScrollView()
    let stackView = UIStackView()
    let interestFilterButton = WSSFilterButton()
    let dividerView = UIView()
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
}

