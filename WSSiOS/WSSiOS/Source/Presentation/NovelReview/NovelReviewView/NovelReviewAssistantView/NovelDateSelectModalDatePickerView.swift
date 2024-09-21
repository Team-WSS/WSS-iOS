//
//  NovelDateSelectModalDatePickerView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 9/21/24.
//

import UIKit

import SnapKit
import Then

final class NovelDateSelectModalDatePickerView: UIView {
    
    //MARK: - Components
    
    let datePicker = UIDatePicker()
    
    //MARK: - Life Cycle
    
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
        datePicker.do {
            $0.datePickerMode = .date
            $0.preferredDatePickerStyle = .wheels
            $0.locale = Locale(identifier: StringLiterals.Register.Normal.DatePicker.KoreaTimeZone)
        }
    }
    
    private func setHierarchy() {
        self.addSubview(datePicker)
    }
    
    private func setLayout() {
        datePicker.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(111)
        }
    }
}
