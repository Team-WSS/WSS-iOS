//
//  NovelDetailInfoReadDateView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 1/12/24.
//

import UIKit

import SnapKit
import Then

final class NovelDetailInfoReadDateView: UIView {

    //MARK: - set Properties

    private var startDate: String = "2023-12-26"
    private var endDate: String = "2023-12-30"
    
    // MARK: - UI Components
    
    private let readDateLabel = UILabel()
    private let dateImageView = UIImageView()
    private let startDateLabel = UILabel()
    private let endDateLabel = UILabel()
    private let waveLabel = UILabel()

    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierachy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - set UI
    
    private func setUI() {
        readDateLabel.do {
            $0.text = "읽은 날짜"
            $0.textColor = .Black
            $0.font = .Title1
        }
        
        dateImageView.do {
            $0.image = ImageLiterals.icon.calender.withRenderingMode(.alwaysTemplate)
            $0.contentMode = .scaleAspectFit
            $0.tintColor = .Black
        }
        
        startDateLabel.do {
            $0.text = self.startDate
            $0.font = .Body2
            $0.textColor = .Gray300
        }
        
        endDateLabel.do {
            $0.text = self.endDate
            $0.font = .Body2
            $0.textColor = .Gray300
        }
        
        waveLabel.do {
            $0.text = "~"
            $0.font = .Body2
            $0.textColor = .Gray300
        }
    }
    
    // MARK: - set Hierachy
    
    private func setHierachy() {
        self.addSubviews(readDateLabel,
                         dateImageView,
                         startDateLabel,
                         waveLabel,
                         endDateLabel)
    }
    
    // MARK: - set Layout
    
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
}
