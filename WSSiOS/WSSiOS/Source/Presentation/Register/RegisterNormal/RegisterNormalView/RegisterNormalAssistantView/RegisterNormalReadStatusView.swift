//
//  RegisterNoemalReadingStatusTest.swift
//  WSSiOS
//
//  Created by 이윤학 on 1/13/24.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

final class RegisterNormalReadStatusView: UIView {
    
    // MARK: - UI Components
    
    private let totalStackView = UIStackView()
    private let titleView = WSSSectionTitleView()
    lazy var readStatusButtons: [RegisterNormalReadStatusButton] = createButtons()
    private let readStatusStackView = UIStackView()
    
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
            $0.spacing = 12
            $0.alignment = .leading
            
            titleView.do {
                $0.setText("읽기 상태 *")
            }
            
            readStatusStackView.do {
                $0.axis = .horizontal
                $0.spacing = 8
            }
        }
    }
    
    private func setHieararchy() {
        self.addSubview(totalStackView)
        totalStackView.addArrangedSubviews(titleView,
                                           readStatusStackView)
        readStatusButtons.forEach {
            readStatusStackView.addArrangedSubview($0)
        }
    }
    
    private func setLayout() {
        totalStackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
    }
    
    private func createButtons() -> [RegisterNormalReadStatusButton] {
        var buttons: [RegisterNormalReadStatusButton] = []
        for status in ReadStatus.allCases {
            let button = RegisterNormalReadStatusButton()
            button.do {
                $0.setText(status.tagText)
                $0.setImage(status.tagImage)
                $0.setStatus(status)
            }
            buttons.append(button)
        }
        
        return buttons
    }
}

