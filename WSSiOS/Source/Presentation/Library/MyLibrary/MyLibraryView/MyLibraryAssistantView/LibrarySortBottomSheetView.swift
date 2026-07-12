//
//  LibrarySortBottomSheetView.swift
//  WSSiOS
//
//  Created by YunhakLee on 6/22/26.
//

import UIKit

import SnapKit
import Then

final class LibrarySortBottomSheetView: UIView {
    
    //MARK: - Components
    
    let backgroundButton = UIButton()
    private let sheetView = UIView()
    private let rowsStackView = UIStackView()
    let sortRowButtons: [LibrarySortRowButton]
    
    //MARK: - Life Cycle
    
    init(currentSort: LibrarySortType) {
        self.sortRowButtons = LibrarySortType.allCases.map { LibrarySortRowButton($0) }
        
        super.init(frame: .zero)
        
        setUI()
        setHierarchy()
        setLayout()
        updateSelection(currentSort)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI
    
    private func setUI() {
        self.backgroundColor = .clear
        
        sheetView.do {
            $0.backgroundColor = .wssWhite
            $0.layer.cornerRadius = 16
            $0.layer.maskedCorners = [.layerMinXMinYCorner,
                                      .layerMaxXMinYCorner]
        }

        rowsStackView.do {
            $0.axis = .vertical
            $0.spacing = 10
            $0.alignment = .fill
            $0.distribution = .fill
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(backgroundButton,
                         sheetView)
        sheetView.addSubview(rowsStackView)
        sortRowButtons.forEach {
            rowsStackView.addArrangedSubview($0)
        }
    }
    
    private func setLayout() {
        backgroundButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        sheetView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
        }

        rowsStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(8)
        }
    }
    
    //MARK: - Custom Method
    
    func updateSelection(_ sort: LibrarySortType) {
        sortRowButtons.forEach {
            $0.setSelected($0.sortType == sort)
        }
    }
}

//MARK: - Row Button

final class LibrarySortRowButton: UIButton {
    
    let sortType: LibrarySortType
    
    private let selectedBackgroundView = UIView()
    private let sortTitleLabel = UILabel()
    private let checkImageView = UIImageView()
    
    init(_ sortType: LibrarySortType) {
        self.sortType = sortType
        
        super.init(frame: .zero)
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        selectedBackgroundView.do {
            $0.backgroundColor = .wssPrimary20
            $0.layer.cornerRadius = 12
            $0.clipsToBounds = true
            $0.isHidden = true
        }
        
        sortTitleLabel.do {
            $0.applyWSSFont(.body2, with: sortType.text)
            $0.textColor = .wssGray200
            $0.isUserInteractionEnabled = false
        }
        
        checkImageView.do {
            $0.image = .icCheck
            $0.isHidden = true
            $0.isUserInteractionEnabled = false
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(selectedBackgroundView,
                         sortTitleLabel,
                         checkImageView)
    }
    
    private func setLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(37)
        }
        
        selectedBackgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        sortTitleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        checkImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(sortTitleLabel.snp.leading).offset(-10)
            $0.size.equalTo(22)
        }
    }
    
    func setSelected(_ isSelected: Bool) {
        selectedBackgroundView.isHidden = !isSelected
        sortTitleLabel.textColor = isSelected ? .wssBlack : .wssGray200
        checkImageView.isHidden = !isSelected
    }
}
