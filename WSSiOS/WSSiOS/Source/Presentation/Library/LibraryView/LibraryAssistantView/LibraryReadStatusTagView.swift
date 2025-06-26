//
//  LibraryReadStatusTagView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 6/26/25.
//

import UIKit

import SnapKit
import Then

final class LibraryReadStatusTagView: UIView {
    
    //MARK: - Components
    
    let statusLabel = UILabel()
    
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
        statusLabel.do {
            $0.textColor = .wssWhite
        }
    }

    private func setHierarchy() {
        self.addSubview(statusLabel)
    }
    
    private func setLayout() {
        statusLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func bindData(readStatus: ReadStatus) {
        self.backgroundColor = readStatus.tagBackgroundColor
        
        statusLabel.do {
            $0.applyWSSFont(.label2, with: readStatus.tagText)
        }
    }
}
