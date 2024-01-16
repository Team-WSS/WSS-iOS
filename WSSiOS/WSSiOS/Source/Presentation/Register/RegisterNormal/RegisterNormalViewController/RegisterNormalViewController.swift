//
//  RegisterNormalViewController.swift
//  WSSiOS
//
//  Created by 이윤학 on 1/6/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

enum RegisterNormalReadStatus: String, CaseIterable {
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
    
    var dateText: String? {
        switch self {
        case .FINISH: return "읽은 날짜"
        case .READING: return "시작 날짜"
        case .DROP: return "종료 날짜"
        case .WISH: return nil
        }
    }
}

/// 1-3-1 RegisterNormal View
final class RegisterNormalViewController: UIViewController {
    
    // MARK: - Properties
    
    // RxSwift에서 메모리 관리를 위한 DisposeBag
    private let disposeBag = DisposeBag()
    
    private var starRating = BehaviorRelay<Float>(value: 0.0)
    private var buttonStatus = BehaviorRelay<RegisterNormalReadStatus>(value: .FINISH)
    private var isOn = BehaviorRelay<Bool>(value: true)
    private var showDatePicker = BehaviorRelay<Bool>(value: false)
    
    private var startDate = BehaviorRelay<Date>(value: Date())
    private var endDate = BehaviorRelay<Date>(value: Date())
    
    private let rootView = RegisterNormalView()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    // MARK: - View Life Cycle
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    // MARK: - Custom Method
    
    private func bind() {
        rootView.infoWithRatingView.starRatingView.do { view in
            
            view.starImageViews.enumerated().forEach { index, imageView in
                
                // StarRating 탭 제스처 인식기 생성 및 설정
                let tapGesture = UITapGestureRecognizer()
                imageView.addGestureRecognizer(tapGesture)
                tapGesture.rx.event
                    .bind(onNext: { recognizer in
                        let location = recognizer.location(in: imageView)
                        let rating = Float(index) + (location.x > imageView.frame.width / 2 ? 1 : 0.5)
                        self.starRating.accept(rating)
                    })
                    .disposed(by: disposeBag)
                
                // StarRating 팬 제스처 인식기 생성 및 설정
                let panGesture = UIPanGestureRecognizer()
                view.addGestureRecognizer(panGesture)
                panGesture.rx.event
                    .bind(onNext: { recognizer in
                        let location = recognizer.location(in: view)
                        let rawRating = (Float(location.x / view.frame.width * 5) * 2).rounded(.toNearestOrAwayFromZero) / 2
                        let rating = min(max(rawRating, 0), 5)
                        self.starRating.accept(rating)
                    })
                    .disposed(by: disposeBag)
            }
            
            // 별점이 변경될 때마다 별 이미지 업데이트
            starRating.asObservable()
                .subscribe(onNext: { rating in
                    view.updateStarImages(rating: rating)
                })
                .disposed(by: disposeBag)
        }
        
        // ReadStatus 에 따른 ReadStatus 선택 뷰 변화
        rootView.readStatusView.do { view in
            for (index, status) in RegisterNormalReadStatus.allCases.enumerated() {
                view.readStatusButtons[index].rx.tap
                    .bind {
                        self.buttonStatus.accept(status)
                    }
                    .disposed(by: disposeBag)
            }

            buttonStatus
                .subscribe(onNext: { status in
                    view.bindReadStatus(status: status)
                })
                .disposed(by: disposeBag)
        }
        
        // ReadStatus 에 따른 날짜 선택 뷰 변화
        rootView.readDateView.do { view in
            buttonStatus
                .subscribe(onNext: { status in
                    if status == .WISH {
                        view.isHidden = true
                    } else {
                        view.isHidden = false
                        view.bindData(status)
                    }
                })
                .disposed(by: disposeBag)
        }
        
        rootView.readDateView.do { view in
            view.toggleButton.rx.tap
                .subscribe(onNext: {
                    let next = !self.isOn.value
                    self.isOn.accept(next)
                })
                .disposed(by: disposeBag)
            
            isOn
                .subscribe(onNext: { isOn in
                    view.toggleButton.changeState(isOn)
                    view.datePickerButton.isHidden = !isOn
                })
                .disposed(by: disposeBag)
            
            view.datePickerButton.rx.tap
                .subscribe(onNext: {
                    let next = !self.showDatePicker.value
                    self.showDatePicker.accept(next)
                    print(next)
                })
                .disposed(by: disposeBag)
        }
        
        rootView.do { view in
            showDatePicker.subscribe(onNext: { value in
                view.customDatePicker.isHidden = !value
            })
            .disposed(by: disposeBag)
            
            view.customDatePicker.rx.tap
                .subscribe(onNext: {
                    let next = !self.showDatePicker.value
                    self.showDatePicker.accept(next)
                    print(next)
                })
                .disposed(by: disposeBag)
            
            view.customDatePicker.completeButton.rx.tap
                .subscribe(onNext: {
                    self.startDate.accept(view.customDatePicker.startDate)
                    self.endDate.accept(view.customDatePicker.endDate)
                    let next = !self.showDatePicker.value
                    self.showDatePicker.accept(next)
                })
                .disposed(by: disposeBag)
            
            startDate.asObservable()
                .map { date in
                    return self.dateFormatter.string(from: date)
                }
                .bind(to: view.readDateView.datePickerButton.startDateLabel.rx.text)
                .disposed(by: disposeBag)
            
            endDate.asObservable()
                .map { date in
                    return self.dateFormatter.string(from: date)
                }
                .bind(to: view.readDateView.datePickerButton.endDateLabel.rx.text)
                .disposed(by: disposeBag)
            
            buttonStatus
                .subscribe(onNext: { status in
                    view.customDatePicker.bindReadStatus(status: status)
                })
                .disposed(by: disposeBag)
        }
    }
}
