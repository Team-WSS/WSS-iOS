//
//  DeletePopupContentView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 1/14/24.
//

import UIKit

import SnapKit
import Then

enum PopupStatus {
    case memoEditCancel
    case memoDelete
    case novelDelete
    
    var titleText: String {
        switch self {
        case .memoEditCancel: StringLiterals.DeletePopup.MemoEditCancel.titleText
        case .memoDelete: StringLiterals.DeletePopup.MemoDelete.titleText
        case .novelDelete: StringLiterals.DeletePopup.NovelDelete.titleText
        }
    }
    
    var descriptionText: String {
        switch self {
        case .memoEditCancel: StringLiterals.DeletePopup.MemoEditCancel.descriptionText
        case .memoDelete: StringLiterals.DeletePopup.MemoDelete.descriptionText
        case .novelDelete: StringLiterals.DeletePopup.NovelDelete.descriptionText
        }
    }
    
    var deleteButtonText: String {
        switch self {
        case .memoEditCancel: StringLiterals.DeletePopup.DeleteButtonText.exit
        case .memoDelete, .novelDelete: StringLiterals.DeletePopup.DeleteButtonText.delete
        }
    }
    
    var cancelButtonText: String {
        switch self {
        case .memoEditCancel: StringLiterals.DeletePopup.CancelButtonText.keepWriting
        case .memoDelete, .novelDelete: StringLiterals.DeletePopup.CancelButtonText.cancel
        }
    }
}

final class DeletePopupContentView: UIView {
    
    //MARK: - Components
    
    private let warningImageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    public let deleteButton = UIButton()
    public let cancelButton = UIButton()

    //MARK: - Life Cycle
    
    init(_ popupStatus: PopupStatus) {
        super.init(frame: .zero)
        
        setUI()
        setHierarchy()
        setLayout()
        
        bindData(popupStatus)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - UI
    
    private func setUI() {
        self.do {
            $0.backgroundColor = .wssWhite
            $0.layer.cornerRadius = 12
        }
        
        warningImageView.do {
            $0.image = .icWarning
            $0.contentMode = .scaleAspectFit
        }
        
        titleLabel.do {
            $0.textColor = .wssBlack
            $0.font = .Title2
        }
        
        descriptionLabel.do {
            $0.textColor = .wssGray200
            $0.font = .Label1
            $0.numberOfLines = 2
        }
        
        deleteButton.do {
            $0.backgroundColor = .wssGray50
            $0.layer.cornerRadius = 8
        }
        
        cancelButton.do {
            $0.backgroundColor = .wssPrimary200
            $0.layer.cornerRadius = 8
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(warningImageView,
                         titleLabel,
                         descriptionLabel,
                         deleteButton,
                         cancelButton)
    }
    
    private func setLayout() {
        warningImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(24)
            $0.size.equalTo(60)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(warningImageView.snp.bottom).offset(18)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
        }
        
        deleteButton.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(18)
            $0.leading.equalToSuperview().inset(21)
            $0.bottom.equalToSuperview().inset(24)
            $0.trailing.equalTo(self.snp.centerX).offset(-9)
            $0.height.equalTo(40)
        }
        
        cancelButton.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(18)
            $0.leading.equalTo(deleteButton.snp.trailing).offset(18)
            $0.trailing.equalToSuperview().inset(21)
            $0.bottom.equalToSuperview().inset(24)
            $0.leading.equalTo(self.snp.centerX).offset(9)
            $0.height.equalTo(40)
        }
    }
    
    //MARK: - Bind
    
    func bindData(_ status: PopupStatus) {
        self.titleLabel.do {
            $0.makeAttribute(with: status.titleText)?
                .lineSpacing(spacingPercentage: 140)
                .kerning(kerningPixel: -0.6)
                .applyAttribute()
        }
        self.descriptionLabel.do {
            $0.makeAttribute(with: status.descriptionText)?
                .lineSpacing(spacingPercentage: 145)
                .applyAttribute()
            $0.textAlignment = .center
        }
        self.deleteButton.setButtonAttributedTitle(text: status.deleteButtonText, font: .Label1, color: .wssGray300)
        self.cancelButton.setButtonAttributedTitle(text: status.cancelButtonText, font: .Label1, color: .wssWhite)
    }
}
