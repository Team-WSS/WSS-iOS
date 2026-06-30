//
//  Untitled.swift
//  WSSiOS
//
//  Created by YunhakLee on 6/26/25.
//

import UIKit

import SnapKit
import Then

final class MyLibraryNavigationView: UIView {
    
    //MARK: - Components

    private let navigationTitle = UILabel()
    let libraryAddButton = UIButton()
    
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
        
        navigationTitle.do {
            $0.applyWSSFont(.headline1, with: StringLiterals.Navigation.Title.library)
            $0.textColor = .wssBlack
        }

        libraryAddButton.do {
            $0.setImage(.icBookPlus, for: .normal)
        }
    }

    private func setHierarchy() {
        addSubviews(navigationTitle, libraryAddButton)
    }

    private func setLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(40)
        }

        navigationTitle.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }

        libraryAddButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
            $0.size.equalTo(24)
        }
    }
}

