//
//  RegisterNormalDate.swift
//  WSSiOS
//
//  Created by 이윤학 on 1/11/24.
//


import UIKit

import SnapKit
import Then

final class RegisterNormalDatePickerButton: UIButton {
    
    // MARK: - UI Components
    
    private let dateLabelStackView = UIStackView()
    let startDateLabel = UILabel()
    let middleLabel = UILabel()
    let endDateLabel = UILabel()
    private let calendarImageView = UIImageView()
    
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
        self.do {
            $0.backgroundColor = .Gray50
            $0.layer.cornerRadius = 15
        }
        
        dateLabelStackView.do {
            $0.axis = .horizontal
            $0.spacing = 20
            $0.alignment = .center
            $0.isUserInteractionEnabled = false
            
            startDateLabel.do {
                $0.text = "2023-12-26"
                dateLabelStyle(of: startDateLabel)
            }
            
            middleLabel.do {
                $0.text = "~"
                dateLabelStyle(of: middleLabel)
            }
            
            endDateLabel.do {
                $0.text = "2023-12-26"
                dateLabelStyle(of: endDateLabel)
            }
        }
        
        calendarImageView.do {
            $0.image = ImageLiterals.icon.calender
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
        }
    }
    
    private func setHieararchy() {
        self.addSubviews(dateLabelStackView,
                         calendarImageView)
        dateLabelStackView.addArrangedSubviews(startDateLabel,
                                               middleLabel,
                                               endDateLabel
        )
    }
    
    private func setLayout() {
        dateLabelStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.top.bottom.equalToSuperview().inset(11)
        }
        
        calendarImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.size.equalTo(18)
            $0.centerY.equalToSuperview()
        }
    }
    
    private func dateLabelStyle(of label: UILabel) {
        label.do {
            $0.makeAttribute(with: label.text)?
                .lineSpacing(spacingPercentage: 150)
                .kerning(kerningPixel: -0.6)
                .applyAttribute()
            $0.font = .Body2
            $0.textColor = .Gray300
        }
    }
    
    func bindData(_ status: ReadStatus) {
        switch status {
        case .FINISH:
            startDateLabel.isHidden = false
            middleLabel.isHidden = false
            endDateLabel.isHidden = false
        case .READING:
            startDateLabel.isHidden = false
            middleLabel.isHidden = true
            endDateLabel.isHidden = true
        case .DROP:
            startDateLabel.isHidden = true
            middleLabel.isHidden = true
            endDateLabel.isHidden = false
        case .WISH:
            break
        }
    }
}
