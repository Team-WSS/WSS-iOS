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
    
    //MARK: - Properties
    
    private let horizontalPadding: CGFloat = 20
    private lazy var backgroundCenter = (UIScreen.main.bounds.width - horizontalPadding*2)/2
    private let animationDuration: Double = 0.25
    private let onColor: UIColor = .wssPrimary100
    private let offColor: UIColor = .wssGray100
    
    //MARK: - Components
    
    private let backgroundView = RegisterNormalDifferentRadiusView(topLeftRadius: 12, topRightRadius: 12)
    private let totalStackView = UIStackView()
    
    private let finishStatusView = UIView()
    private let buttonBackgroundView = UIView()
    
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
    let completeButton = WSSMainButton(title: StringLiterals.Register.Normal.DatePicker.complete)
    
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
        self.do {
            $0.backgroundColor = .wssBlack60
        }
        backgroundView.do {
            $0.backgroundColor = .wssWhite
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
            $0.locale = Locale(identifier: StringLiterals.Register.Normal.DatePicker.KoreaTimeZone)
        }
        
        finishStatusView.do {
            $0.backgroundColor = .wssGray50
            $0.layer.cornerRadius = 5
            
            startButton.backgroundColor = .clear
            
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
            
            endButton.backgroundColor = .clear
            
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
            
            buttonBackgroundView.do {
                $0.backgroundColor = .wssWhite
                $0.layer.cornerRadius = 5
                $0.layer.borderWidth = 1
                $0.layer.borderColor = UIColor.wssPrimary50.cgColor
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
    
    private func setHierarchy() {
        self.addSubview(backgroundView)
        backgroundView.addSubviews(totalStackView,
                                   completeButton)
        totalStackView.addArrangedSubviews(finishStatusView,
                                           readingStatusLabel,
                                           dropStatusLabel,
                                           datePicker)
        finishStatusView.addSubviews(buttonBackgroundView,
                                     startButton,
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
            $0.horizontalEdges.equalToSuperview().inset(horizontalPadding)
            $0.bottom.equalTo(completeButton.snp.top).offset(-35)
        }
        
        readingStatusLabel.snp.makeConstraints {
            $0.height.equalTo(42)
        }
        
        dropStatusLabel.snp.makeConstraints {
            $0.height.equalTo(42)
        }
        
        startButton.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(finishStatusView.snp.centerX)
        }
        
        endButton.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.leading.equalTo(finishStatusView.snp.centerX)
            $0.trailing.equalToSuperview()
        }
        
        startButtonStackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(10)
            $0.centerX.equalToSuperview()
        }
        
        endButtonStackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(10)
            $0.centerX.equalToSuperview()
        }
        
        buttonBackgroundView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(finishStatusView.snp.leading)
            $0.width.equalTo(startButton.snp.width)
            $0.height.equalTo(startButton.snp.height)
        }
        
        completeButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(10)
        }
    }
    
    //MARK: - Custom Method
    
    func updateDatePickerTitle(status: TrashReadStatus) {
        if status == .FINISH {
            finishStatusView.isHidden = false
            readingStatusLabel.isHidden = true
            dropStatusLabel.isHidden = true
        } else if status == .DROP {
            finishStatusView.isHidden = true
            dropStatusLabel.isHidden = false
            readingStatusLabel.isHidden = true
        } else if status == .READING {
            finishStatusView.isHidden = true
            dropStatusLabel.isHidden = true
            readingStatusLabel.isHidden = false
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
    
    func updateButtons(_ isStart: Bool) {
        UIView.animate(withDuration: self.animationDuration) {
            self.updateWhiteBackgroundLayout(isStart)
            self.layoutIfNeeded()
        }
        UIView.transition(with: self.startTitleLabel,
                          duration: self.animationDuration,
                          options: .transitionCrossDissolve) {
            self.startTitleLabel.textColor = isStart ? self.onColor : self.offColor
        }
        UIView.transition(with: self.startDateLabel,
                          duration: self.animationDuration,
                          options: .transitionCrossDissolve) {
            self.startDateLabel.textColor = isStart ? self.onColor : self.offColor
        }
        UIView.transition(with: self.endTitleLabel,
                          duration: self.animationDuration,
                          options: .transitionCrossDissolve) {
            self.endTitleLabel.textColor = isStart ? self.offColor : self.onColor
        }
        UIView.transition(with: self.endDateLabel,
                          duration: self.animationDuration,
                          options: .transitionCrossDissolve) {
            self.endDateLabel.textColor = isStart ? self.offColor : self.onColor
        }
    }
    
    private func updateWhiteBackgroundLayout(_ isStart: Bool) {
        if isStart {
            buttonBackgroundView.snp.updateConstraints {
                $0.leading.equalTo(finishStatusView.snp.leading)
            }
        } else {
            buttonBackgroundView.snp.updateConstraints {
                $0.leading.equalTo(finishStatusView.snp.leading).inset(backgroundCenter)
            }
        }
    }
    
    private func dateLabelStyle(of label: UILabel) {
        label.do {
            $0.makeAttribute()?
                .lineSpacing(spacingPercentage: 145)
                .applyAttribute()
            $0.font = .Label1
        }
    }
    
    private func titleLabelStyle(of label: UILabel) {
        label.do {
            $0.makeAttribute()?
                .lineSpacing(spacingPercentage: 140)
                .kerning(kerningPixel: -0.6)
                .applyAttribute()
            $0.font = .Title2
        }
    }
}
