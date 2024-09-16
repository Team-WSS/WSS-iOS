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
    
    //MARK: - Components
    
    private let totalStackView = UIStackView()
    
    private let upperStackView = UIStackView()
    private let titleView = WSSSectionTitleView()
    let toggleButton = RegisterNormalToggleButton()
    private let spacer = UIView()
    
    let datePickerButton = UIButton()
    private let dateLabelStackView = UIStackView()
    private let startDateLabel = UILabel()
    private let middleLabel = UILabel()
    private let endDateLabel = UILabel()
    private let calendarImageView = UIImageView()
    
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
        totalStackView.do {
            $0.axis = .vertical
            $0.spacing = 8
            $0.alignment = .fill
            
            upperStackView.do {
                $0.axis = .horizontal
                $0.spacing = 14
                $0.alignment = .center
                
                titleView.do {
                    $0.setText(StringLiterals.Register.Normal.SectionTitle.readStatus)
                }
            }
            
            datePickerButton.do {
                $0.backgroundColor = .wssGray50
                $0.layer.cornerRadius = 15
            }
            
            dateLabelStackView.do {
                $0.axis = .horizontal
                $0.spacing = 20
                $0.alignment = .center
                $0.isUserInteractionEnabled = false
                
                middleLabel.do {
                    $0.text = StringLiterals.Register.Normal.DatePicker.middle
                    dateLabelStyle(of: middleLabel)
                }
            }
            
            calendarImageView.do {
                $0.image = .icCalendar
                $0.contentMode = .scaleAspectFill
                $0.clipsToBounds = true
            }
        }
    }
    
    private func setHierarchy() {
        self.addSubview(totalStackView)
        totalStackView.addArrangedSubviews(upperStackView,
                                           datePickerButton)
        upperStackView.addArrangedSubviews(titleView,
                                           toggleButton,
                                           spacer)
        datePickerButton.addSubviews(dateLabelStackView,
                         calendarImageView)
        dateLabelStackView.addArrangedSubviews(startDateLabel,
                                               middleLabel,
                                               endDateLabel)
    }
    
    private func setLayout() {
        totalStackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
            
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
    }
    
    //MARK: - Custom Method
    
    func updateDatePickerButton(_ status: TrashReadStatus) {
        titleView.setText(status.dateText)
        
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
    
    func setStartDateText(text: String) {
        startDateLabel.text = text
        dateLabelStyle(of: startDateLabel)
    }
    
    func setEndDateText(text: String) {
        endDateLabel.text = text
        dateLabelStyle(of: endDateLabel)
    }
    
    private func dateLabelStyle(of label: UILabel) {
        label.do {
            $0.makeAttribute(with: label.text)?
                .lineSpacing(spacingPercentage: 150)
                .kerning(kerningPixel: -0.6)
                .applyAttribute()
            $0.font = .Body2
            $0.textColor = .wssGray300
        }
    }
}
