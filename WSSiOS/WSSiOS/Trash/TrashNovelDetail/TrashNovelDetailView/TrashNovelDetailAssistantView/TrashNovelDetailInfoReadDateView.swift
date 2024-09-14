//
//  TrashNovelDetailInfoReadDateView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 1/12/24.
//

import UIKit

import SnapKit
import Then

final class TrashNovelDetailInfoReadDateView: UIView {
    
    //MARK: - Components
    
    private let readDateLabel = UILabel()
    private let dateImageView = UIImageView()
    private let startDateLabel = UILabel()
    private let endDateLabel = UILabel()
    private let waveLabel = UILabel()

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
        readDateLabel.do {
            $0.textColor = .wssBlack
            $0.font = .Title1
        }
        
        dateImageView.do {
            $0.image = .icCalendar.withRenderingMode(.alwaysTemplate)
            $0.contentMode = .scaleAspectFit
            $0.tintColor = .wssBlack
        }
        
        startDateLabel.do {
            $0.font = .Body2
            $0.textColor = .wssGray300
        }
        
        endDateLabel.do {
            $0.font = .Body2
            $0.textColor = .wssGray300
        }
        
        waveLabel.do {
            $0.makeAttribute(with: "")?
                .lineSpacing(spacingPercentage: 150)
                .kerning(kerningPixel: -0.6)
                .applyAttribute()
            $0.font = .Body2
            $0.textColor = .wssGray300
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(readDateLabel,
                         dateImageView,
                         startDateLabel,
                         waveLabel,
                         endDateLabel)
    }
    
    private func setLayout() {
        readDateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(35)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        dateImageView.snp.makeConstraints {
            $0.top.equalTo(readDateLabel.snp.bottom).offset(15)
            $0.leading.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(6)
            $0.size.equalTo(18)
        }
        
        startDateLabel.snp.makeConstraints {
            $0.centerY.equalTo(dateImageView.snp.centerY)
            $0.leading.equalTo(dateImageView.snp.trailing).offset(9)
        }
        
        waveLabel.snp.makeConstraints {
            $0.centerY.equalTo(dateImageView.snp.centerY)
            $0.leading.equalTo(startDateLabel.snp.trailing).offset(20)
        }
        
        endDateLabel.snp.makeConstraints {
            $0.centerY.equalTo(dateImageView.snp.centerY)
            $0.leading.equalTo(waveLabel.snp.trailing).offset(20)
        }
    }
    
    //MARK: - Data
    
    func bindData(startDate: String, endDate: String?) {
        self.startDateLabel.do {
            $0.makeAttribute(with: startDate)?
                .lineSpacing(spacingPercentage: 150)
                .kerning(kerningPixel: -0.6)
                .applyAttribute()
        }
        if let endDate = endDate {
            self.readDateLabel.do {
                $0.makeAttribute(with: "")?
                    .kerning(kerningPixel: -0.6)
                    .applyAttribute()
            }
            self.endDateLabel.do {
                $0.makeAttribute(with: endDate)?
                    .lineSpacing(spacingPercentage: 150)
                    .kerning(kerningPixel: -0.6)
                    .applyAttribute()
            }
            self.waveLabel.isHidden = false
        } else {
            self.readDateLabel.do {
                $0.makeAttribute(with: "")?
                    .kerning(kerningPixel: -0.6)
                    .applyAttribute()
            }
            self.endDateLabel.text = nil
            self.waveLabel.isHidden = true
        }
    }
}
