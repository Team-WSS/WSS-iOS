//
//  NovelDateSelectModalDateButtonView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 9/21/24.
//

import UIKit

import SnapKit
import Then

final class NovelDateSelectModalDateButtonView: UIView {
    
    //MARK: - Components
    
    private let stackView = UIStackView()
    let startDateButton = UIButton()
    private let startDateLabelWrapperView = UIStackView()
    private let startDateTitleLabel = UILabel()
    private let startDateLabel = UILabel()
    let endDateButton = UIButton()
    private let endDateLabelWrapperView = UIStackView()
    private let endDateTitleLabel = UILabel()
    private let endDateLabel = UILabel()
    
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
        stackView.do {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.backgroundColor = .wssGray50
            $0.layer.cornerRadius = 12
        }
        
        startDateButton.do {
            $0.backgroundColor = .wssWhite
            $0.layer.cornerRadius = 12
            $0.layer.borderColor = UIColor.wssGray50.cgColor
            $0.layer.borderWidth = 2
        }
        
        startDateLabelWrapperView.do {
            $0.axis = .vertical
            $0.alignment = .center
            $0.distribution = .equalSpacing
            $0.spacing = 2
            $0.isUserInteractionEnabled = false
        }
        
        startDateTitleLabel.do {
            $0.applyWSSFont(.title2, with: StringLiterals.NovelReview.Date.startDate)
            $0.isUserInteractionEnabled = false
        }
        
        startDateLabel.do {
            $0.isUserInteractionEnabled = false
        }
        
        endDateButton.do {
            $0.backgroundColor = .wssWhite
            $0.layer.cornerRadius = 12
            $0.layer.borderColor = UIColor.wssGray50.cgColor
            $0.layer.borderWidth = 2
        }
        
        endDateLabelWrapperView.do {
            $0.axis = .vertical
            $0.alignment = .center
            $0.distribution = .equalSpacing
            $0.spacing = 2
            $0.isUserInteractionEnabled = false
        }
        
        endDateTitleLabel.do {
            $0.applyWSSFont(.title2, with: StringLiterals.NovelReview.Date.endDate)
            $0.isUserInteractionEnabled = false
        }
        
        endDateLabel.do {
            $0.isUserInteractionEnabled = false
        }
    }
    
    private func setHierarchy() {
        self.addSubview(stackView)
        stackView.addArrangedSubviews(startDateButton,
                                      endDateButton)
        startDateButton.addSubview(startDateLabelWrapperView)
        startDateLabelWrapperView.addArrangedSubviews(startDateTitleLabel,
                                                      startDateLabel)
        endDateButton.addSubview(endDateLabelWrapperView)
        endDateLabelWrapperView.addArrangedSubviews(endDateTitleLabel,
                                                    endDateLabel)
    }
    
    private func setLayout() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(63)
        }
        
        startDateLabelWrapperView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        endDateLabelWrapperView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    //MARK: - Custom Method
    
    func updateDateButtonStyle(isStartDateSelected: Bool) {
        startDateButton.backgroundColor = isStartDateSelected ? .wssWhite : .wssGray50
        startDateTitleLabel.textColor = isStartDateSelected ? .wssBlack : .wssGray200
        startDateLabel.textColor = isStartDateSelected ? .wssBlack : .wssGray200
        
        endDateButton.backgroundColor = isStartDateSelected ? .wssGray50 : .wssWhite
        endDateTitleLabel.textColor = isStartDateSelected ? .wssGray200 : .wssBlack
        endDateLabel.textColor = isStartDateSelected ? .wssGray200 : .wssBlack
    }
    
    func updateStartDate(startDate: String) {
        startDateLabel.do {
            $0.applyWSSFont(.body4, with: startDate)
        }
    }
    
    func updateEndDate(endDate: String) {
        endDateLabel.do {
            $0.applyWSSFont(.body4, with: endDate)
        }
    }
}
