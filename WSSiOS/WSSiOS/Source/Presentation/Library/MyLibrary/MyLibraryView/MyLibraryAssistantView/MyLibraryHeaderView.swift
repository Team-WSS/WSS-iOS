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
    
    private let filterHeaderView = MyLibraryFilterHeaderView()
    private let bottomContentView = UIView()
    private let countLabel = UILabel()
    private let sortButton = WSSSortButton()
    private let layoutToggleButton = UIButton()
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
            $0.applyWSSFont(.body4, with: StringLiterals.MyLibrary.novelCountText(13))
        }
        
        sortButton.do {
            $0.updateSortButton(sortType: .newest)
        }
        
        layoutToggleButton.do {
            $0.setImage(.layoutList.withTintColor(.wssGray100), for: .normal)
            $0.configuration = .plain()
            $0.configuration?.background.backgroundColor = .white
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
            $0.trailing.equalTo(layoutToggleButton.snp.leading).offset(-20.5)
        }
        
        layoutToggleButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(9.5)
            $0.size.equalTo(33)
        }
        
        dividerView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
}

