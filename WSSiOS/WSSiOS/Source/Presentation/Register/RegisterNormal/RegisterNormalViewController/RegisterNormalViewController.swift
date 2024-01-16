//
//  RegisterNormalViewController.swift
//  WSSiOS
//
//  Created by 이윤학 on 1/6/24.
//

import UIKit

import Kingfisher
import RxSwift
import RxCocoa
import SnapKit
import Then

/// 1-3-1 RegisterNormal View
final class RegisterNormalViewController: UIViewController {
    
    // MARK: - Properties
    
    // 서버 통신을 위한 properties
    let localData: EditNovelResult?
    private let repository: NovelRepository
    private let novelId: Int?
    
    // RxSwift
    private let disposeBag = DisposeBag()
    private var starRating = BehaviorRelay<Float>(value: 0.0)
    private var readStatus = BehaviorRelay<ReadStatus>(value: .FINISH)
    private var isOn = BehaviorRelay<Bool>(value: true)
    private var showDatePicker = BehaviorRelay<Bool>(value: false)
    private var startDate = BehaviorRelay<Date>(value: Date())
    private var endDate = BehaviorRelay<Date>(value: Date())
    
    private let rootView = RegisterNormalView()
    
    // Date -> String
    let dateToString = DateFormatter().then {
        $0.dateFormat = "yyyy-MM-dd"
    }
    // String -> Date
    let stringToDate = DateFormatter().then {
        $0.dateFormat = "yyyy-MM-dd"
        $0.timeZone = TimeZone(identifier: "ko_KR")
    }
    
    // MARK: - View Life Cycle
    
    init(repository: NovelRepository, novelId: Int? = nil, userNovelModel: EditNovelResult? = nil) {
        self.repository = repository
        self.novelId = novelId
        self.localData = userNovelModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = rootView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getNovel()
        bindRx()
    }
    
    // MARK: - Custom Method
    
    private func getNovel() {
        repository.getNovelInfo(novelId: novelId)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { data in
                self.bindData(data)
            },onError: { error in
                print("ERROR!!!")
                if let localData = self.localData {
                    self.bindData(localData)
                }
            }).disposed(by: disposeBag)
    }
    
    private func bindData(_ data: NovelResult) {
        if let editNovelResult = data.editNovelResult {
            bindData(editNovelResult)
            print("Edit!")
        }
        
        if let newNovelResult = data.newNovelResult {
            bindData(newNovelResult)
            print("New!")
            print(newNovelResult.novelID)
        }
    }
    
    private func bindData(_ newData: NewNovelResult) {
        rootView.bannerImageView.bindData(newData.novelImg)
        rootView.infoWithRatingView.bindData(coverImage: newData.novelImg,
                                             title: newData.novelTitle,
                                             author: newData.novelAuthor)
        rootView.novelSummaryView.bindData(plot: newData.novelDescription, genre: newData.novelGenre)
    }
    
    private func bindData(_ userData: EditNovelResult) {
        rootView.bannerImageView.bindData(userData.userNovelImg)
        rootView.infoWithRatingView.bindData(coverImage: userData.userNovelImg,
                                             title: userData.userNovelTitle,
                                             author: userData.userNovelAuthor)
        self.starRating.accept(userData.userNovelRating)
        
        let status = ReadStatus(rawValue: userData.userNovelReadStatus) ?? .FINISH
        self.readStatus.accept(status)
        
        // status에 따른 날짜 처리
        var start = ""
        var end = ""
        
        if status == .FINISH {
            start = userData.userNovelReadDate.userNovelReadStartDate ?? ""
            end = userData.userNovelReadDate.userNovelReadEndDate ?? ""
        } else if status == .READING {
            end = userData.userNovelReadDate.userNovelReadStartDate ?? ""
        } else if status == .DROP {
            start = userData.userNovelReadDate.userNovelReadEndDate ?? ""
        }
        
        self.startDate.accept(
            dateToString.date(from: start) ?? Date()
        )
        self.endDate.accept(
            dateToString.date(from: end) ?? Date()
        )
        
        rootView.novelSummaryView.bindData(plot: userData.userNovelDescription, genre: userData.userNovelGenre)
    }
    
    private func bindRx() {
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
            for (index, status) in ReadStatus.allCases.enumerated() {
                view.readStatusButtons[index].rx.tap
                    .bind {
                        self.readStatus.accept(status)
                    }
                    .disposed(by: disposeBag)
            }

            readStatus
                .subscribe(onNext: { status in
                    view.bindReadStatus(status: status)
                })
                .disposed(by: disposeBag)
        }
    
        // ReadStatus 에 따른 날짜 선택 뷰 변화
        rootView.readDateView.do { view in
            readStatus
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
            showDatePicker.subscribe(with: self, onNext: { owner, show in
                if show {
                    view.customDatePicker.startDate = self.startDate.value
                    view.customDatePicker.endDate = self.endDate.value
                }
                view.customDatePicker.isHidden = !show
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
                .map { self.dateToString.string(from: $0) }
                .bind(to: view.readDateView.datePickerButton.startDateLabel.rx.text)
                .disposed(by: disposeBag)
            
            endDate.asObservable()
                .map { self.dateToString.string(from: $0) }
                .bind(to: view.readDateView.datePickerButton.endDateLabel.rx.text)
                .disposed(by: disposeBag)
            
            readStatus
                .subscribe(onNext: { status in
                    view.customDatePicker.bindReadStatus(status: status)
                })
                .disposed(by: disposeBag)
        }
    }
    
    // 나중에 효원에게 넘겨받을 것
    private func bindEditData(data: UserNovelDetail) {
        let editData = EditNovelResult(userNovelID: novelId ?? 0,
                                   userNovelTitle: data.userNovelTitle,
                                   userNovelAuthor: data.userNovelAuthor,
                                   userNovelGenre: data.userNovelGenre,
                                   userNovelImg: data.userNovelImg,
                                   userNovelDescription: data.userNovelDescription,
                                   userNovelRating: data.userNovelRating,
                                   userNovelReadStatus: data.userNovelReadStatus,
                                   platforms: data.platforms,
                                   userNovelReadDate: UserNovelReadDate(
                                    userNovelReadStartDate: data.userNovelReadStartDate,
                                    userNovelReadEndDate: data.userNovelReadEndDate))
    }
}
