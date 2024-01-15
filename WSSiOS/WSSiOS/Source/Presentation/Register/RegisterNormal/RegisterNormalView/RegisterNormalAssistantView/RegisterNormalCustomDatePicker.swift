//
//  RegisterNormalCustomDatePicker.swift
//  WSSiOS
//
//  Created by 이윤학 on 1/15/24.
//

import UIKit

import SnapKit
import Then

final class RegisterNormalCustomDatePicker: UIButton {
    
    //MARK: - Properties
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    // MARK: - UI Components
    
    private let background = UIView()
    private let totalStackView = UIStackView()
    
    private let buttonStackView = UIStackView()
    
    private let startButton = UIButton()
    private let startButtonStackView = UIStackView()
    private let startTitleLabel = UILabel()
    private let startDateLabel = UILabel()
    
    private let endButton = UIButton()
    private let endButtonStackView = UIStackView()
    private let endTitleLabel = UILabel()
    private let endDateLabel = UILabel()
    
    private let readingStatusLabel = UILabel()
    private let dropStatusLabel = UILabel()
    
    private let datePicker = UIDatePicker()
    
    let completeButton = WSSMainButton(title: "완료")
    
    var startDate = Date() {
        didSet {
            startDateLabel.text = dateFormatter.string(from: startDate)
        }
    }
    var endDate = Date() {
        didSet {
            endDateLabel.text = dateFormatter.string(from: endDate)
        }
    }
    
    var selectedButton: UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHieararchy()
        setLayout()
        selectedButton = startButton
        isStart(true)
        setActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        self.do {
            $0.backgroundColor = .Black.withAlphaComponent(0.6)
        }
        background.do {
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
                        $0.text = "시작 날짜"
                        buttonTitleStyle(of: $0)
                    }
                    
                    startDateLabel.do {
                        $0.text = dateFormatter.string(from: startDate)
                        buttonDateStyle(of: $0)
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
                        $0.text = "종료 날짜"
                        buttonTitleStyle(of: $0)
                    }
                    
                    endDateLabel.do {
                        $0.text = dateFormatter.string(from: endDate)
                        buttonDateStyle(of: $0)
                    }
                }
            }
        }
        
        readingStatusLabel.do {
            $0.text = "시작 날짜"
            $0.makeAttribute()?
                .kerning(kerningPixel: -0.6)
                .lineSpacing(spacingPercentage: 140)
                .applyAttribute()
            $0.textAlignment = .center
            $0.font = .Title2
        }
        
        dropStatusLabel.do {
            $0.text = "종료 날짜"
            $0.makeAttribute()?
                .kerning(kerningPixel: -0.6)
                .lineSpacing(spacingPercentage: 140)
                .applyAttribute()
            $0.textAlignment = .center
            $0.font = .Title2
        }
    }
    
    private func setHieararchy() {
        self.addSubview(background)
        background.addSubviews(totalStackView,
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
        background.snp.makeConstraints {
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
        
        datePicker.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(completeButton.snp.top).offset(-35)
        }
        
        completeButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(10)
        }
    }
    
    func bindReadStatus(status: RegisterNormalReadStatus) {
        if status == .FINISH {
            buttonStackView.isHidden = false
            readingStatusLabel.isHidden = true
            dropStatusLabel.isHidden = true
            selectedButton = startButton
        } else if status == .DROP {
            buttonStackView.isHidden = true
            readingStatusLabel.isHidden = true
            dropStatusLabel.isHidden = false
            selectedButton = endButton
        } else if status == .READING {
            buttonStackView.isHidden = true
            readingStatusLabel.isHidden = false
            dropStatusLabel.isHidden = true
            selectedButton = startButton
        }
    }
    
    func setActions() {
        startButton.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        endButton.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
    }
    
    @objc func didTapButton(_ sender: UIButton) {
        selectedButton = sender
        isStart(sender == startButton)
    }
    
    @objc func dateChanged() {
        let selectedDate = datePicker.date
        
        if selectedButton == startButton && selectedDate >= endDate {
            startDate = selectedDate
            endDate = selectedDate
        } else if selectedButton == endButton && selectedDate <= startDate {
            startDate = selectedDate
            endDate = selectedDate
        } else if selectedButton == startButton {
            startDate = selectedDate
        } else if selectedButton == endButton {
            endDate = selectedDate
        }
    }
    
    private func isStart(_ isStart: Bool) {
        if isStart {
            datePicker.date = startDate
        } else {
            datePicker.date = endDate
        }
        
        startTitleLabel.textColor = isStart ? .Primary100 : .Gray100
        startDateLabel.textColor = isStart ? .Primary100 : .Gray100
        startButton.backgroundColor = isStart ? .White : .Gray50
        startButton.layer.borderColor = isStart ? UIColor.Primary50.cgColor : UIColor.Gray50.cgColor
        endTitleLabel.textColor = isStart ? .Gray100 : .Primary100
        endDateLabel.textColor = isStart ? .Gray100 : .Primary100
        endButton.backgroundColor = isStart ? .Gray50 : .White
        endButton.layer.borderColor = isStart ? UIColor.Gray50.cgColor : UIColor.Primary50.cgColor
    }
    
    private func buttonDateStyle(of label: UILabel) {
        label.do {
            $0.makeAttribute(with: $0.text)?
                .lineSpacing(spacingPercentage: 145)
                .applyAttribute()
            $0.font = .Label1
        }
    }
    
    private func buttonTitleStyle(of label: UILabel) {
        label.do {
            $0.makeAttribute(with: $0.text)?
                .lineSpacing(spacingPercentage: 140)
                .kerning(kerningPixel: -0.6)
                .applyAttribute()
            $0.font = .Title2
        }
    }
}
