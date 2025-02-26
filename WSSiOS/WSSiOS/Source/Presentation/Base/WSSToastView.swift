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
    case blockUser(nickname: String)
    case unknownUser
    case deleteBlockUser(nickname: String)
    case novelAlreadyConnected
    case selectionOverLimit(count: Int)
    case novelReviewed
    case novelReviewDeleted
    case feedEdited
    case changePublic
    case changePrivate
    case changeUserInfo
    case editUserProfile

    var toastImage: UIImage {
        switch self {
        case .deleteBlockUser, .novelAlreadyConnected, .selectionOverLimit, .unknownUser:
            return .icAlertSuccess
        case .novelReviewed, .novelReviewDeleted, .feedEdited, .blockUser, .changePublic, .changePrivate, .changeUserInfo, .editUserProfile:
            return .icAlertCheck
        }
    }
    
    var toastText: String {
        switch self {
        case .blockUser(let nickname):
            "\(nickname)님을 차단했어요"
        case .deleteBlockUser(let nickname):
            "\(nickname)님을 차단 해제했어요"
        case .novelAlreadyConnected:
            "하나의 작품만 연결할 수 있어요"
        case .selectionOverLimit(let count):
            "\(count)개까지 선택 가능해요"
        case .novelReviewed:
            "평가 완료!"
        case .novelReviewDeleted:
            "평가를 모두 삭제했어요"
        case .feedEdited:
            "작성 완료!"
        case .unknownUser:
            "웹소소를 떠난 유저예요"
        case .changePublic:
            "프로필이 전체 공개로 전환되었어요"
        case .changePrivate:
            "프로필이 비공개로 전환되었어요"
        case .changeUserInfo:
            "성별/나이 정보가 수정되었어요"
        case .editUserProfile:
            "프로필 정보가 수정되었어요"
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
        setLayout()
        
        bindData(toastStatus)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
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
            $0.numberOfLines = 2
        }
    }
    
    private func setHierachy() {
        self.addSubviews(toastImageView,
                         descriptionLabel)
    }
    
    private func setLayout() {
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
    }
    
    //MARK: - Data
    
    private func bindData(_ status: ToastStatus) {
        self.toastImageView.image = status.toastImage
        self.descriptionLabel.applyWSSFont(.body1, with: status.toastText)
    }
}
