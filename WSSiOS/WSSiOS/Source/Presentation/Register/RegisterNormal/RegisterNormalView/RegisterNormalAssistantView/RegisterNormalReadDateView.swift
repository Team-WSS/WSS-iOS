//
//  RegisterNormalReadDateView.swift
//  WSSiOS
//
//  Created by 이윤학 on 1/11/24.
//

import UIKit

import SnapKit
import Then

final class RegisterNormalReadDateView: UIView {
    
    // MARK: - UI Components
    
    private let totalStackView = UIStackView()
    private let upperStackView = UIStackView()
    private let titleView = WSSSectionTitleView()
    let toggleButton = RegisterNormalCustomToggleButton()
    let datePickerButton = RegisterNormalDatePickerButton()
    private let spacer = UIView()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHieararchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Method
    
    private func setUI() {
        totalStackView.do {
            $0.axis = .vertical
            $0.spacing = 8
            $0.alignment = .fill
            
            upperStackView.do {
                $0.axis = .horizontal
                $0.spacing = 14
                $0.alignment = .center
                
                titleView.do {
                    $0.setText(StringLiterals.Register.Normal.SectinoTitle.readStatus)
                }
            }
        }
    }
    
    private func setHieararchy() {
        self.addSubview(totalStackView)
        totalStackView.addArrangedSubviews(upperStackView,
                                           datePickerButton)
        upperStackView.addArrangedSubviews(titleView,
                                           toggleButton,
                                           spacer)
    }
    
    private func setLayout() {
        totalStackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
    }
    
    func bindData(_ status: ReadStatus) {
        titleView.setText(status.dateText)
        datePickerButton.bindData(status)
    }
}
