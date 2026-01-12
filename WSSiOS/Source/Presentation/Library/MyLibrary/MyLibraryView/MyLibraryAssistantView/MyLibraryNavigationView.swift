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
    }
    
    private func setHierarchy() {
        addSubviews(navigationTitle)
    }
    
    private func setLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(56)
        }
        
        navigationTitle.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
    }
}

