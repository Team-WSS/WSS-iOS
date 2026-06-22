//
//  MyLibraryHeaderView.swift
//  WSSiOS
//
//  Created by YunhakLee on 6/26/25.
//

import UIKit

import SnapKit
import Then

final class MyLibraryHeaderView: UIView {
    
    //MARK: - Components
    
    let filterHeaderView = MyLibraryFilterHeaderView()
    private let bottomContentView = UIView()
    private let countLabel = UILabel()
    let sortButton = WSSSortButton()
    let layoutToggleButton = UIButton()
    let layoutToggleButtonImageView = UIImageView()
    private let dividerView = UIView()
    
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
        
        countLabel.do {
            $0.textColor = .wssGray200
        }
        
        sortButton.do {
            $0.updateSortButton(sortType: .createdDesc)
        }
        
        layoutToggleButton.do {
            $0.configuration = .plain()
            $0.configuration?.background.backgroundColor = .white
        }
        
        layoutToggleButtonImageView.do {
            $0.image = .layoutGrid.withTintColor(.wssGray100)
            $0.isUserInteractionEnabled = false
        }
        
        dividerView.do {
            $0.backgroundColor = .wssGray50
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(filterHeaderView,
                         bottomContentView)
        bottomContentView.addSubviews(countLabel,
                                      sortButton,
                                      layoutToggleButton,
                                      dividerView)
        layoutToggleButton.addSubview(layoutToggleButtonImageView)
    }
    
    private func setLayout() {
        filterHeaderView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        bottomContentView.snp.makeConstraints {
            $0.top.equalTo(filterHeaderView.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        countLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
        
        sortButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(layoutToggleButton.snp.leading).offset(-10)
        }
        
        layoutToggleButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
            $0.size.equalTo(33)
        }
        
        layoutToggleButtonImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.size.equalTo(12)
        }
        
        dividerView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    func updateLayoutToggleButton(selectedType: LayoutType) {
        layoutToggleButtonImageView.image = selectedType.image.withTintColor(.wssGray100)
    }
    
    func updateCountLabel(count: Int) {
        countLabel.applyWSSFont(.body4, with: StringLiterals.MyLibrary.novelCountText(count))
    }
}

