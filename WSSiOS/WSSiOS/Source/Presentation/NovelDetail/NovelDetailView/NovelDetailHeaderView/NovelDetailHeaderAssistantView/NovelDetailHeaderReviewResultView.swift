//
//  NovelDetailNovelRatingView.swift
//  WSSiOS
//
//  Created by 이윤학 on 4/29/24.
//

import UIKit

import SnapKit
import Then

final class NovelDetailHeaderReviewResultView: UIView {

    //MARK: - Components
    
    private let totalStackView = UIStackView()
    
    private let readInfoButtonStackView = UIStackView()
    private let readInfoButtons = [NovelDetailHeaderReadInfoButton(iconImage: .icSmallStar),
                                   NovelDetailHeaderReadInfoButton(iconImage: .icSmallCalendar)]
    
    private let readStatusButtonStackView = UIStackView()
    private let readStatusButtons = ReadStatus.allCases.map {
        NovelDetailHeaderReadStatusButton(readStatus: $0)
    }
    private let divierViews = [UIView(), UIView()]
    
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
            $0.backgroundColor = .wssWhite
            $0.layer.cornerRadius = 15
            $0.layer.borderColor = UIColor.wssGray80.cgColor
            $0.layer.borderWidth = 1
        }
        
        totalStackView.do {
            $0.axis = .vertical
            $0.alignment = .center
            $0.spacing = 10
        }
        
        readInfoButtonStackView.do {
            $0.axis = .horizontal
            $0.alignment = .center
            $0.spacing = 8
        }
        
        readStatusButtonStackView.do {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
        }
        
        divierViews.forEach {
            $0.backgroundColor = .wssGray70
        }
    }
    
    private func setHierarchy() {
        self.addSubview(totalStackView)
        totalStackView.addArrangedSubviews(readInfoButtonStackView,
                                           readStatusButtonStackView)
        readInfoButtons.forEach { button in
            readInfoButtonStackView.addArrangedSubview(button)
        }
        readStatusButtons.forEach { button in
            readStatusButtonStackView.addArrangedSubview(button)
        }
        divierViews.forEach { view in
            readStatusButtonStackView.addSubview(view)
        }
    }
    
    private func setLayout() {
        totalStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(15)
            $0.horizontalEdges.equalToSuperview().inset(10)
        }
        
        readStatusButtonStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
        }
        
        divierViews[0].snp.makeConstraints {
            $0.height.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.equalTo(1)
            $0.centerX.equalTo(readStatusButtons[0].snp.trailing)
            
        }
        
        divierViews[1].snp.makeConstraints {
            $0.height.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.equalTo(1)
            $0.centerX.equalTo(readStatusButtons[1].snp.trailing)
        }
    }
    
    //MARK: - Data
    
    func bindData(_ data: NovelDetailHeaderResult) {
        let readStatus = ReadStatus(rawValue: data.readStatus ?? "")
        
        readStatusButtons.forEach { readStatusButton in
            readStatusButton.updateButton(selectedStatus: readStatus)
        }
        let isUserRatingExist = 0.0 != data.userNovelRating
        let isDateExist = data.startDate != nil || data.endDate != nil
        
        if !isUserRatingExist && !isDateExist {
            readInfoButtonStackView.isHidden = true
        } else if !isUserRatingExist {
            readInfoButtons[0].isHidden = true
        } else if !isDateExist {
            readInfoButtons[1].isHidden = true
        }
        
        let userNovelRatingText = String(format: "%1.1f", data.userNovelRating)
        var dateText = "~"
        if let startDate = data.startDate {
            dateText = "\(startDate) " + dateText
        }
        if let endDate = data.endDate {
            dateText = dateText + " \(endDate)"
        }
        
        readInfoButtons[0].bindData(infoText: userNovelRatingText)
        readInfoButtons[1].bindData(infoText: dateText)
    }
    
    //MARK: - Custom Method
    
}
