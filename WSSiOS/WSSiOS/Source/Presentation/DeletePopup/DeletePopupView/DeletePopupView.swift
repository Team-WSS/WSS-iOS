//
//  DeletePopupView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 1/14/24.
//

import UIKit

import SnapKit
import Then

final class DeletePopupView: UIView {
    
    // MARK: - UI Components
    
    let deletePopupContentView = DeletePopupContentView()

    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierachy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - set UI
    
    private func setUI() {
        self.backgroundColor = .Black.withAlphaComponent(0.6)
    }
    
    // MARK: - set Hierachy
    
    private func setHierachy() {
        self.addSubview(deletePopupContentView)
    }
    
    // MARK: - set Layout
    
    private func setLayout() {
        deletePopupContentView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(41.5)
        }
    }
}
