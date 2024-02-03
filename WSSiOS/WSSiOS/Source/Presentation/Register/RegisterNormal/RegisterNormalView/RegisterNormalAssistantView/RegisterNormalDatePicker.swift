//
//  RegisterNormalDatePicker.swift
//  WSSiOS
//
//  Created by 이윤학 on 1/15/24.
//

import UIKit

import SnapKit
import Then

final class RegisterNormalDatePicker: UIButton {
    
    // MARK: - UI Components
    
    private let backgroundView = UIView()
    private let totalStackView = UIStackView()
    
    private let buttonStackView = UIStackView()
    
    let startButton = UIButton()
    private let startButtonStackView = UIStackView()
    private let startTitleLabel = UILabel()
    private let startDateLabel = UILabel()
    
    let endButton = UIButton()
    private let endButtonStackView = UIStackView()
    private let endTitleLabel = UILabel()
    private let endDateLabel = UILabel()
    
    private let readingStatusLabel = UILabel()
    private let dropStatusLabel = UILabel()
    
    let datePicker = UIDatePicker()
    
    let completeButton = WSSMainButton(title: "완료")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHieararchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        self.do {
            $0.backgroundColor = .Black.withAlphaComponent(0.6)
        }
        backgroundView.do {
            $0.backgroundColor = .White
            $0.layer.cornerRadius = 12
        }
        
        totalStackView.do {
            $0.axis = .vertical
            $0.alignment = .fill
            // 원래 35인데, DatePicker가 커스텀 되지 않아 시각적으로 더 멀어 보여서 줄였음.
            $0.spacing = 20
        }
        
        datePicker.do {
            $0.datePickerMode = .date
            $0.preferredDatePickerStyle = .wheels
            $0.locale = Locale(identifier: "ko_KR")
        }
        
        buttonStackView.do {
            $0.axis = .horizontal
            $0.backgroundColor = .Gray50
            $0.distribution = .fillEqually
            $0.layer.cornerRadius = 5
            
            startButton.do {
                $0.layer.cornerRadius = 5
                $0.layer.borderWidth = 1
                $0.layer.borderColor = UIColor.Primary50.cgColor
                
                startButtonStackView.do {
                    $0.axis = .vertical
                    $0.spacing = 2
                    $0.alignment = .center
                    $0.isUserInteractionEnabled = false
                    
                    startTitleLabel.do {
                        $0.text = StringLiterals.Register.Normal.DatePicker.start
                        titleLabelStyle(of: $0)
                    }
                }
            }
            
            endButton.do {
                $0.layer.cornerRadius = 5
                $0.layer.borderWidth = 1
                $0.layer.borderColor = UIColor.Gray50.cgColor
                
                endButtonStackView.do {
                    $0.axis = .vertical
                    $0.spacing = 2
                    $0.alignment = .center
                    $0.isUserInteractionEnabled = false
                    
                    endTitleLabel.do {
                        $0.text = StringLiterals.Register.Normal.DatePicker.end
                        titleLabelStyle(of: $0)
                    }
                }
            }
        }
        
        readingStatusLabel.do {
            $0.text = StringLiterals.Register.Normal.DatePicker.start
            $0.makeAttribute()?
                .kerning(kerningPixel: -0.6)
                .lineSpacing(spacingPercentage: 140)
                .applyAttribute()
            $0.textAlignment = .center
            $0.font = .Title2
        }
        
        dropStatusLabel.do {
            $0.text = StringLiterals.Register.Normal.DatePicker.end
            $0.makeAttribute()?
                .kerning(kerningPixel: -0.6)
                .lineSpacing(spacingPercentage: 140)
                .applyAttribute()
            $0.textAlignment = .center
            $0.font = .Title2
        }
    }
    
    private func setHieararchy() {
        self.addSubview(backgroundView)
        backgroundView.addSubviews(totalStackView,
                               completeButton)
        totalStackView.addArrangedSubviews(buttonStackView,
                                           readingStatusLabel,
                                           dropStatusLabel,
                                           datePicker)
        buttonStackView.addArrangedSubviews(startButton,
                                            endButton)
        startButton.addSubview(startButtonStackView)
        endButton.addSubview(endButtonStackView)
        startButtonStackView.addArrangedSubviews(startTitleLabel,
                                                 startDateLabel)
        endButtonStackView.addArrangedSubviews(endTitleLabel,
                                               endDateLabel)
    }
    
    private func setLayout() {
        backgroundView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        totalStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(34)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(completeButton.snp.top).offset(-35)
        }
        
        readingStatusLabel.snp.makeConstraints {
            $0.height.equalTo(42)
        }
        
        dropStatusLabel.snp.makeConstraints {
            $0.height.equalTo(42)
        }
        
        startButtonStackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(10)
            $0.centerX.equalToSuperview()
        }
        
        endButtonStackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(10)
            $0.centerX.equalToSuperview()
        }
        
        completeButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(10)
        }
    }
    
    func updateDatePicker(date: Date) {
        datePicker.date = date
    }
    
    func setStartDateText(text: String) {
        startDateLabel.text = text
        dateLabelStyle(of: startDateLabel)
    }
    
    func setEndDateText(text: String) {
        endDateLabel.text = text
        dateLabelStyle(of: endDateLabel)
    }
    
    func updateDatePicker(status: ReadStatus) {
        if status == .FINISH {
            buttonStackView.isHidden = false
            readingStatusLabel.isHidden = true
            dropStatusLabel.isHidden = true
        } else if status == .DROP {
            buttonStackView.isHidden = true
            dropStatusLabel.isHidden = false
            readingStatusLabel.isHidden = true
        } else if status == .READING {
            buttonStackView.isHidden = true
            dropStatusLabel.isHidden = true
            readingStatusLabel.isHidden = false
        }
    }
    
    func updateButtons(_ isStart: Bool) {
        startTitleLabel.textColor = isStart ? .Primary100 : .Gray100
        startDateLabel.textColor = isStart ? .Primary100 : .Gray100
        startButton.backgroundColor = isStart ? .White : .Gray50
        startButton.layer.borderColor = isStart ? UIColor.Primary50.cgColor : UIColor.Gray50.cgColor
        endTitleLabel.textColor = isStart ? .Gray100 : .Primary100
        endDateLabel.textColor = isStart ? .Gray100 : .Primary100
        endButton.backgroundColor = isStart ? .Gray50 : .White
        endButton.layer.borderColor = isStart ? UIColor.Gray50.cgColor : UIColor.Primary50.cgColor
    }
    
    private func dateLabelStyle(of label: UILabel) {
        label.do {
            $0.makeAttribute(with: $0.text)?
                .lineSpacing(spacingPercentage: 145)
                .applyAttribute()
            $0.font = .Label1
        }
    }
    
    private func titleLabelStyle(of label: UILabel) {
        label.do {
            $0.makeAttribute(with: $0.text)?
                .lineSpacing(spacingPercentage: 140)
                .kerning(kerningPixel: -0.6)
                .applyAttribute()
            $0.font = .Title2
        }
    }
}
