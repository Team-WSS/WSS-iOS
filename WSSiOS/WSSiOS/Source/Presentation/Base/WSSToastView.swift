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
    case nicknameSave
    case deleteBlockUser(nickname: String)
    case novelAlreadyConnected
    case selectionOverLimit(count: Int)
    case novelReviewed
    case novelReviewDeleted

    var toastImage: UIImage {
        switch self {
        case .memoSaveSuccess, .nicknameSave, .memoEditSuccess, .deleteBlockUser, .novelAlreadyConnected, .selectionOverLimit:
            return .icAlertSuccess
        case .memoSaveFail, .memoDelete:
            return .icAlertWarning
        case .novelReviewed, .novelReviewDeleted:
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
        case .nicknameSave:
            "닉네임을 저장했어요"
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
