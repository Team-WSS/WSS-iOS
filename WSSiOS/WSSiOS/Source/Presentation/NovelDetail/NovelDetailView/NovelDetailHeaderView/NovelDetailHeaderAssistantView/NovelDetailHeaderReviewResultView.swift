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
    let readInfoButtons = [NovelDetailHeaderReadInfoButton(iconImage: .icSmallStar),
                           NovelDetailHeaderReadInfoButton(iconImage: .icSmallCalendar)]
    
    private let readStatusButtonStackView = UIStackView()
    let readStatusButtons = ReadStatus.allCases.map {
        NovelDetailHeaderReadStatusButton(readStatus: $0)
    }
    private let dividerViews = [UIView(), UIView()]
    
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
            $0.isHidden = true
        }
        
        readInfoButtons.forEach { button in
            button.isHidden = true
        }
        
        readStatusButtonStackView.do {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
        }
        
        dividerViews.forEach {
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
        dividerViews.forEach { view in
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
        
        dividerViews.enumerated().forEach { index, divierView in
            divierView.snp.makeConstraints {
                $0.height.equalToSuperview()
                $0.centerY.equalToSuperview()
                $0.width.equalTo(1)
                $0.centerX.equalTo(readStatusButtons[index].snp.trailing)
            }
        }
    }
    
    //MARK: - Data
    
    func bindData(_ data: NovelDetailHeaderEntity) {
        readStatusButtons.forEach {
            $0.updateButton(selectedStatus: data.readStatus)
        }
        bindVisibility(data.isUserNovelRatingExist, data.isReadDateExist)
        
        let readDateText = [data.startDate, "~", data.endDate]
            .compactMap { $0 }
            .joined(separator: " ")
        readInfoButtons[0].bindData(infoText: "\(data.userNovelRating)")
        readInfoButtons[1].bindData(infoText: readDateText)
    }
    
    //MARK: - Custom Method
    
    func bindVisibility(_ isUserNovelRatingExist: Bool, _ isReadDateExist: Bool) {
        if !isUserNovelRatingExist && !isReadDateExist {
            readInfoButtonStackView.isHidden = true
        } else if !isUserNovelRatingExist {
            readInfoButtonStackView.isHidden = false
            readInfoButtons[0].isHidden = true
            readInfoButtons[1].isHidden = false
        } else if !isReadDateExist {
            readInfoButtonStackView.isHidden = false
            readInfoButtons[0].isHidden = false
            readInfoButtons[1].isHidden = true
        } else {
            readInfoButtonStackView.isHidden = false
            readInfoButtons[0].isHidden = false
            readInfoButtons[1].isHidden = false
        }
    }
}
