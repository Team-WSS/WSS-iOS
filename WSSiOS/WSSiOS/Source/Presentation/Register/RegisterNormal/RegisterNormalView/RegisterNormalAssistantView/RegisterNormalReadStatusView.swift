//
//  RegisterNormalReadStatusView.swift
//  WSSiOS
//
//  Created by 이윤학 on 1/9/24.
//


import UIKit

import SnapKit
import Then

final class RegisterNormalReadStatusView: UIView {
    
    // MARK: - Properties
    
    let buttonTitles = ["읽음", "읽는 중", "하차", "읽고 싶음"]
    let buttonImages: [UIImage] = [ImageLiterals.icon.TagStatus.finished,
                                   ImageLiterals.icon.TagStatus.reading,
                                   ImageLiterals.icon.TagStatus.stop,
                                   ImageLiterals.icon.TagStatus.interest]
    
    // MARK: - UI Components
    
    private let totalStackView = UIStackView()
    private let titleView = WSSSectionTitleView()
    private lazy var readStatusButtons: [UIButton] = createButtons()
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
    
    private func createButtons() -> [UIButton] {
        var buttons: [UIButton] = []
        for index in 0..<4 {
            let button = RegisterNormalReadStatusButton()
            button.do {
                $0.setText(buttonTitles[index])
                $0.setImage(buttonImages[index])
                $0.tag = index
            }
            buttons.append(button)
        }
        
        return buttons
    }
}
