//
//  LibraryFilterPublicationStatusButton.swift
//  WSSiOS
//
//  Created by YunhakLee on 6/21/26.
//

import UIKit

import SnapKit
import Then

final class LibraryFilterPublicationStatusButton: UIButton {
    
    //MARK: - Properties
    
    let status: PublicationStatus
    
    //MARK: - UI Components
    
    private let box = KeywordBox()
    
    //MARK: - Life Cycle
    
    init(_ status: PublicationStatus) {
        self.status = status
        
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
        box.do {
            $0.isUserInteractionEnabled = false
            $0.setText(status.description)
        }
    }
    
    private func setHierarchy() {
        self.addSubview(box)
    }
    
    private func setLayout() {
        box.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    //MARK: - Custom Method
    
    func updateButton(isSelected: Bool) {
        box.updateColor(isSelected)
    }
}
