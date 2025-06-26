//
//  LibraryFilterReadStatusView.swift
//  WSSiOS
//
//  Created by YunhakLee on 5/26/25.
//

import UIKit

import SnapKit
import Then

final class LibraryFilterReadStatusView: UIView {
    
    //MARK: - UI Components
    
    private let titleLabel = UILabel()
    private let readStatusOptionstackView = UIStackView()
    private let readStatusOptionButtons = ReadStatus.allCases.map {
        LibraryFilterReadStatusOptionButton($0)
    }
    private let dividerViews = [UIView(), UIView()]
    
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
            $0.applyWSSFont(.title2, with: StringLiterals.MyLibrary.Filter.readStatus)
            $0.textColor = .wssBlack
        }
        
        readStatusOptionstackView.do {
            $0.axis = .horizontal
            $0.spacing = 0
            $0.alignment = .center
            $0.distribution = .fillEqually
        }
        
        dividerViews.forEach {
            $0.backgroundColor = .wssGray70
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(titleLabel,
                         readStatusOptionstackView)
        dividerViews.forEach {
            self.addSubview($0)
        }
        readStatusOptionButtons.forEach {
            readStatusOptionstackView.addArrangedSubview($0)
        }
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().inset(20)
        }
        
        readStatusOptionstackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(54)
        }
        
        dividerViews.enumerated().forEach { index, dividerView in
            dividerView.snp.makeConstraints {
                $0.height.equalTo(32)
                $0.width.equalTo(1)
                $0.centerY.equalTo(readStatusOptionstackView.snp.center)
                $0.centerX.equalTo(readStatusOptionButtons[index].snp.trailing)
            }
        }
    }
}
