//
//  LibraryFilterPublicationStatusView.swift
//  WSSiOS
//
//  Created by YunhakLee on 6/21/26.
//

import UIKit

import SnapKit
import Then

final class LibraryFilterPublicationStatusView: UIView {
    
    //MARK: - UI Components
    
    private let statusStackView = UIStackView()
    let statusButtons = PublicationStatus.allCases.map {
        LibraryFilterPublicationStatusButton($0)
    }
    
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
        statusStackView.do {
            $0.axis = .horizontal
            $0.spacing = 11
            $0.alignment = .center
        }
    }
    
    private func setHierarchy() {
        self.addSubview(statusStackView)
        statusButtons.forEach {
            statusStackView.addArrangedSubview($0)
        }
    }
    
    private func setLayout() {
        statusStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    //MARK: - Custom Method
    
    func updateSelection(_ selected: [PublicationStatus]) {
        statusButtons.forEach {
            $0.updateButton(isSelected: selected.contains($0.status))
        }
    }
}
