//
//  LibraryListView.swift
//  WSSiOS
//
//  Created by 신지원 on 1/15/24.
//

import UIKit

import SnapKit
import Then

final class LibraryListView: UIView {
    
    //MARK: - Components
    
    private let dividerView = UIView()
    public lazy var libraryNewestButton = UIButton()
    public lazy var libraryOldestButton = UIButton()
    
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
        self.do {
            $0.backgroundColor = .wssWhite
            $0.layer.cornerRadius = 12
            $0.layer.shadowColor = UIColor.wssBlack.withAlphaComponent(0.11).cgColor
            $0.layer.shadowOpacity = 1
            $0.layer.shadowOffset = CGSize(width: 0, height: 2)
            $0.layer.shadowRadius = 15
        }
        
        libraryNewestButton.setTitle(StringLiterals.Alignment.newest.title, for: .normal)
        libraryOldestButton.setTitle(StringLiterals.Alignment.oldest.title, for: .normal)
        
        [libraryNewestButton,libraryOldestButton].forEach {
            $0.do {
                $0.setTitleColor(.wssBlack, for: .normal)
                $0.titleLabel?.font = .Body2
                $0.titleLabel?.textAlignment = .left
            }
        }
        
        dividerView.do {
            $0.backgroundColor = .wssGray50
        }
    }

    private func setHierarchy() {
        self.addSubviews(libraryNewestButton,
                         dividerView,
                         libraryOldestButton)
    }
    
    private func setLayout() {
        libraryNewestButton.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(15)
        }
        
        dividerView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(0.7)
        }
        
        libraryOldestButton.snp.makeConstraints {
            $0.top.equalTo(dividerView.snp.bottom).offset(15)
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.bottom.equalToSuperview().inset(15)
        }
    }
}
