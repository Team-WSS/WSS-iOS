//
//  WSSToastView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 1/17/24.
//

import UIKit

import SnapKit
import Then

enum ToastStatus {
    case memoSaveSuccess
    case memoSaveFail
    case memoEditSuccess
    case memoDelete
    case avatarUnlock
    case nicknameSave
    
    var toastImage: UIImage {
        switch self {
        case .memoSaveSuccess, .nicknameSave, .memoEditSuccess:
            return .icAlertSuccess
        case .memoSaveFail, .memoDelete:
            return .icAlertWarning
        case .avatarUnlock:
            return .icAlertCheck
        }
    }
    
    var toastText: String {
        switch self {
        case .memoSaveSuccess:
            "메모를 저장했어요"
        case .memoSaveFail:
            "메모 저장에 실패했어요"
        case .memoEditSuccess:
            "메모를 수정했어요"
        case .memoDelete:
            "메모를 삭제했어요"
        case .avatarUnlock:
            "새 캐릭터가 열렸어요!\n마이페이지에서 확인하세요"
        case .nicknameSave:
            "닉네임을 저장했어요"
        }
    }
}

final class WSSToastView: UIView {
    
    // MARK: - UI Components
    
    private let toastImageView = UIImageView()
    private let descriptionLabel = UILabel()
    
    // MARK: - Life Cycle
    
    
    init(_ toastStatus: ToastStatus) {
        super.init(frame: .zero)
        
        setUI()
        setHierachy()
        
        bindData(toastStatus)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Method
    
    private func setUI() {
        self.do {
            $0.backgroundColor = .wssGrayToast.withAlphaComponent(0.8)
            $0.layer.cornerRadius = 20
        }
        
        toastImageView.do {
            $0.contentMode = .scaleAspectFit
        }
        
        descriptionLabel.do {
            $0.textColor = .wssGray50
            $0.font = .Body1
            $0.numberOfLines = 2
        }
    }
    
    private func setHierachy() {
        self.addSubviews(toastImageView,
                         descriptionLabel)
    }
    
    func bindData(_ status: ToastStatus) {
        self.toastImageView.image = status.toastImage
        self.descriptionLabel.do {
            $0.makeAttribute(with: status.toastText)?
                .lineSpacing(spacingPercentage: 140)
                .kerning(kerningPixel: -0.8)
                .applyAttribute()
        }
        self.setLayout(status)
    }
    
    func setLayout(_ status: ToastStatus) {
        switch status {
        case .memoSaveSuccess, .memoSaveFail, .memoEditSuccess, .memoDelete, .nicknameSave:
            toastImageView.snp.makeConstraints {
                $0.top.bottom.equalToSuperview().inset(14)
                $0.leading.equalToSuperview().inset(20)
                $0.size.equalTo(24)
            }
            
            descriptionLabel.snp.makeConstraints {
                $0.top.bottom.equalToSuperview().inset(14)
                $0.leading.equalTo(toastImageView.snp.trailing).offset(8)
                $0.trailing.equalToSuperview().inset(20)
            }
        case .avatarUnlock:
            toastImageView.snp.makeConstraints {
                $0.top.equalToSuperview().inset(14)
                $0.leading.equalToSuperview().inset(20)
                $0.size.equalTo(24)
            }
            
            descriptionLabel.snp.makeConstraints {
                $0.top.bottom.equalToSuperview().inset(14)
                $0.leading.equalTo(toastImageView.snp.trailing).offset(8)
                $0.trailing.equalToSuperview().inset(60)
            }
        }
    }
}
