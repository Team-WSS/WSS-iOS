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
    
    //MARK: - Components
    
    var deletePopupContentView: DeletePopupContentView

    //MARK: - Life Cycle
    
    init(_ popupStatus: PopupStatus) {
        deletePopupContentView = DeletePopupContentView(popupStatus)
        super.init(frame: .zero)
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - UI
    
    private func setUI() {
        self.backgroundColor = .wssBlack.withAlphaComponent(0.6)
    }
    
    private func setHierarchy() {
        self.addSubview(deletePopupContentView)
    }
    
    private func setLayout() {
        deletePopupContentView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(41.5)
        }
    }
}
