//
//  NovelDateSelectModalView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 9/21/24.
//

import UIKit

import SnapKit
import Then

final class NovelDateSelectModalView: UIView {
    
    //MARK: - Components
    
    let contentView = UIView()
    private let indicatorBackgroundView = UIView()
    let stackView = UIStackView()
    let closeButton = UIButton()
    let novelDateSelectModalTitleView = NovelDateSelectModalTitleView()
    let novelDateSelectModalDateButtonView = NovelDateSelectModalDateButtonView()
    let novelDateSelectModalButtonView = NovelDateSelectModalButtonView()
    
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
        contentView.do {
            $0.backgroundColor = .wssWhite
            $0.layer.cornerRadius = 16
            $0.layer.maskedCorners = [.layerMinXMinYCorner,
                                      .layerMaxXMinYCorner]
        }
        
        indicatorBackgroundView.do {
            $0.backgroundColor = .wssWhite
        }
        
        closeButton.do {
            $0.setImage(.icCacelModal, for: .normal)
        }
        
        stackView.do {
            $0.alignment = .fill
            $0.axis = .vertical
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(contentView,
                         indicatorBackgroundView)
        contentView.addSubviews(stackView,
                                closeButton)
        stackView.addArrangedSubviews(novelDateSelectModalTitleView,
                                      novelDateSelectModalDateButtonView,
                                      novelDateSelectModalButtonView)
    }
    
    private func setLayout() {
        contentView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.safeAreaLayoutGuide)
        }
        
        indicatorBackgroundView.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(65)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
            
            stackView.do {
                $0.setCustomSpacing(25, after: novelDateSelectModalTitleView)
                $0.setCustomSpacing(17, after: novelDateSelectModalDateButtonView)
            }
        }
        
        closeButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview()
            $0.size.equalTo(65)
        }
    }
    
    //MARK: - Data
    
    func bindData(readStatus: ReadStatus) {
        switch readStatus {
        case .watching:
            self.novelDateSelectModalTitleView.bindData(title: StringLiterals.NovelReview.Date.startDate)
            self.novelDateSelectModalDateButtonView.removeFromSuperview()
            
            stackView.snp.updateConstraints {
                $0.top.equalToSuperview().inset(25)
            }
        case .watched:
            self.novelDateSelectModalTitleView.removeFromSuperview()
            
            stackView.snp.updateConstraints {
                $0.top.equalToSuperview().inset(65)
            }
        case .quit:
            self.novelDateSelectModalTitleView.bindData(title: StringLiterals.NovelReview.Date.endDate)
            self.novelDateSelectModalDateButtonView.removeFromSuperview()
            
            stackView.snp.updateConstraints {
                $0.top.equalToSuperview().inset(25)
            }
        }
    }
}
