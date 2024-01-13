//
//  RegisterNoemalReadingStatusTest.swift
//  WSSiOS
//
//  Created by 이윤학 on 1/13/24.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

enum ReadStatus: String, CaseIterable {
    case FINISH
    case READING
    case DROP
    case WISH
    
    var tagImage: UIImage {
        switch self {
        case .FINISH: return ImageLiterals.icon.TagStatus.finished
        case .READING: return ImageLiterals.icon.TagStatus.reading
        case .DROP: return ImageLiterals.icon.TagStatus.stop
        case .WISH: return ImageLiterals.icon.TagStatus.interest
        }
    }
    
    var tagText: String {
        switch self {
        case .FINISH: return "읽음"
        case .READING: return "읽는 중"
        case .DROP: return "하차"
        case .WISH: return "읽고 싶음"
        }
    }
}

final class RegisterNormalReadStatusView: UIView {
    
    // MARK: - Properties
    var buttonStatusSubject = BehaviorSubject<ReadStatus>(value: .FINISH)
    var disposeBag = DisposeBag()
    
    // MARK: - UI Components
    
    private let totalStackView = UIStackView()
    private let titleView = WSSSectionTitleView()
    private lazy var readStatusButtons: [RegisterNormalReadStatusButton] = createButtons()
    private let readStatusStackView = UIStackView()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHieararchy()
        setLayout()
        bindButtonStatus()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Method
    
    private func setUI() {
        totalStackView.do {
            $0.axis = .vertical
            $0.spacing = 12
            $0.alignment = .leading
            
            titleView.do {
                $0.setText("읽기 상태 *")
            }
            
            readStatusStackView.do {
                $0.axis = .horizontal
                $0.spacing = 8
            }
        }
    }
    
    private func setHieararchy() {
        self.addSubview(totalStackView)
        totalStackView.addArrangedSubviews(titleView,
                                           readStatusStackView)
        readStatusButtons.forEach {
            readStatusStackView.addArrangedSubview($0)
        }
    }
    
    private func setLayout() {
        totalStackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
    }
    
    private func createButtons() -> [RegisterNormalReadStatusButton] {
        var buttons: [RegisterNormalReadStatusButton] = []
        for status in ReadStatus.allCases {
            let button = RegisterNormalReadStatusButton()
            button.do {
                $0.setText(status.tagText)
                $0.setImage(status.tagImage)
                $0.setStatus(status)
                $0.rx.tap.bind {
                    self.buttonStatusSubject.onNext(status)
                }.disposed(by: disposeBag)
            }
            buttons.append(button)
        }
        
        return buttons
    }
    
    private func bindButtonStatus() {
        buttonStatusSubject.subscribe(onNext: { status in
            self.readStatusButtons.forEach { button in
                if button.checkStatus(status) {
                    // 활성화 상태 설정
                    button.insertImage()
                    button.setColor(.Primary100)
                } else {
                    // 비활성화 상태 설정
                    button.removeImage()
                    button.setColor(.Gray200)
                }
            }
        }).disposed(by: disposeBag)
    }
}

