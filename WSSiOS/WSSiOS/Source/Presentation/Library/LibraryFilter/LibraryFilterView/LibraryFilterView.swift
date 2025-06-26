//
//  LibraryFilterView.swift
//  WSSiOS
//
//  Created by YunhakLee on 5/26/25.
//

import UIKit

import SnapKit
import Then

final class LibraryFilterView: UIView {
    
    //MARK: - UI Components
    
    private let contentView = UIView()
    private let titleLabel = UILabel()
    let dismissButton = UIButton()
    let readStatusView = LibraryFilterReadStatusView()
    
    let bottomActionView = WSSSearchBottomActionView()
    
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
        contentView.do {
            $0.backgroundColor = .wssWhite
            $0.layer.cornerRadius = 16
            $0.layer.maskedCorners = [.layerMinXMinYCorner,
                                      .layerMaxXMinYCorner]
        }
        
        titleLabel.do {
            $0.applyWSSFont(.body2, with: StringLiterals.MyLibrary.Filter.title)
            $0.textColor = .wssGray200
        }
        
        dismissButton.setImage(.icCancelModal.withTintColor(.wssGray300),
                               for: .normal)
    }
    
    private func setHierarchy() {
        self.addSubviews(contentView)
        contentView.addSubviews(titleLabel,
                                dismissButton,
                                readStatusView,
                                bottomActionView)
    }
    
    private func setLayout() {
        contentView.snp.makeConstraints {
            $0.bottom.horizontalEdges.equalToSuperview()
            $0.height.equalTo(UIScreen.isSE ? 487 : 522)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(20)
        }
        
        dismissButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview()
            $0.size.equalTo(65)
        }
        
        readStatusView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(22)
            $0.horizontalEdges.equalToSuperview()
        }
        
        bottomActionView.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
        }
    }
}
