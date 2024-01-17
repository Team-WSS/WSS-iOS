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
        case .memoEditCancel: "작성을 취소할까요?"
        case .memoDelete: "메모를 삭제하실 건가요?"
        case .novelDelete: "이 작품을 삭제하실 건가요?"
        }
    }
    
    var descriptionText: String {
        switch self {
        case .memoEditCancel: "작성 중인 내용이 모두 사라져요!"
        case .memoDelete: "삭제한 메모는 다시 되돌릴 수 없어요!"
        case .novelDelete: "읽기 정보와 작성한 메모가 모두 사라져요!\n삭제한 내용은 절대 되돌릴 수 없어요ㅠ"
        }
    }
    
    var deleteButtonText: String {
        switch self {
        case .memoEditCancel: "나가기"
        case .memoDelete, .novelDelete: "삭제하기"
        }
    }
    
    var cancelButtonText: String {
        switch self {
        case .memoEditCancel: "계속 작성하기"
        case .memoDelete, .novelDelete: "취소"
        }
    }
}

final class DeletePopupContentView: UIView {
    
    // MARK: - UI Components
    
    private let warningImageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    public let deleteButton = UIButton()
    public let cancelButton = UIButton()

    // MARK: - Life Cycle
    
    init(_ popupStatus: PopupStatus) {
        super.init(frame: .zero)
        
        setUI()
        setHierachy()
        setLayout()
        
        bindData(popupStatus)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - set UI
    
    private func setUI() {
        self.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 12
        }
        
        warningImageView.do {
            $0.image = ImageLiterals.icon.warning
            $0.contentMode = .scaleAspectFit
        }
        
        titleLabel.do {
            $0.textColor = .Black
            $0.font = .Title2
        }
        
        descriptionLabel.do {
            $0.textColor = .Gray200
            $0.font = .Label1
            $0.numberOfLines = 2
            $0.textAlignment = .center
        }
        
        deleteButton.do {
            $0.backgroundColor = .Gray50
            $0.layer.cornerRadius = 8
        }
        
        cancelButton.do {
            $0.backgroundColor = .Primary200
            $0.layer.cornerRadius = 8
        }
    }
    
    // MARK: - set Hierachy
    
    private func setHierachy() {
        self.addSubviews(warningImageView,
                         titleLabel,
                         descriptionLabel,
                         deleteButton,
                         cancelButton)
    }
    
    // MARK: - set Layout
    
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
            $0.width.equalTo(116)
            $0.height.equalTo(40)
        }
        
        cancelButton.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(18)
            $0.leading.equalTo(deleteButton.snp.trailing).offset(18)
            $0.trailing.equalToSuperview().inset(21)
            $0.bottom.equalToSuperview().inset(24)
            $0.width.equalTo(116)
            $0.height.equalTo(40)
        }
    }
    
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
        }
        self.deleteButton.setButtonAttributedTitle(text: status.deleteButtonText, font: .Label1, color: .Gray300)
        self.cancelButton.setButtonAttributedTitle(text: status.cancelButtonText, font: .Label1, color: .white)
    }
}
